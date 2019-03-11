module Measures
  # Utility class for building test patients
  class PatientBuilder

    INSURANCE_TYPES = {
      'MA' => 'Medicare',
      'MC' => 'Medicaid',
      'OT' => 'Other'
    }

    INSURANCE_CODES = {
      'MA' => '1',
      'MC' => '2',
      'OT' => '349'
    }

    CODE_SOURCE = {
      DEFAULT: 'DEFAULT',
      USER_DEFINED: 'USER_DEFINED'
    }

    def self.rebuild_patient(patient)
      patient.medical_record_number ||= Digest::SHA2.hexdigest("#{patient.first} #{patient.last} #{Time.now}")
      patient.medical_record_assigner ||= "Bonnie"
      vs_oids = patient.source_data_criteria.collect{|dc| get_vs_oids(dc)}.flatten.uniq

      oid_to_vs_hash =  Hash[*CQM::ValueSet.in({oid: vs_oids, user_id: patient.user_id}).collect{|vs| [vs.oid,vs]}.flatten]
      sections = {}
      entries = {}
      patient.source_data_criteria.each  do |source_criteria|
        next if source_criteria['id'] == 'MeasurePeriod'
        data_criteria = nil
        begin
          data_criteria = HQMF::DataCriteria.get_settings_for_definition(source_criteria['definition'], source_criteria['status'])
        rescue
          #unsupported data criteria.
          puts $!
        end
        entry = Measures::PatientBuilder.derive_entry(data_criteria, source_criteria, oid_to_vs_hash)

        # if its a thing like result, condition, encounter it will have an entry otherwise
        # its most likely a characteristic
        if entry
          if source_criteria["criteria_id"]
            entries[source_criteria["criteria_id"]] = entry
          end

          derive_values(entry, source_criteria['value'] ,oid_to_vs_hash)
          derive_negation(entry, source_criteria, oid_to_vs_hash)
          derive_field_values(entry, source_criteria['field_values'],oid_to_vs_hash)

          entry_type = HQMF::Generator.classify_entry(data_criteria['patient_api_function'].to_sym)
          section_name = (entry_type == "lab_results") ? "results" : entry_type

          source_criteria['coded_entry_id'] = entry.id

          source_criteria['codes'] = entry['codes']
          if source_criteria['code_source'] != CODE_SOURCE[:USER_DEFINED]
            source_criteria['code_source'] = CODE_SOURCE[:DEFAULT]
          end

          # Add the updated section to this patient.
          sections[section_name] ||= []
          sections[section_name].push(entry)
        end
      end


      # if the patient is persisted, mongoid will send the updates at this point.
      Record::Sections.each do |section|
        patient.send(section).clear.concat(sections[section.to_s] || [])
      end

      # now handle all of the references -- this needs to be done after all of the entries have been materialized
      # because there is no guarantee of order in the source data criteria

      patient.source_data_criteria.each  do |source_criteria|
        refs = nil
        if source_criteria["references"]
          refs = []
          source_ref = entries[source_criteria["criteria_id"]]
          if source_ref
            source_criteria["references"].each do |ref|
              #find the referenced entry in the list of materialized objects
              entry = entries[ref["reference_id"]]
              if entry
                source_ref.add_reference(entry,ref["reference_type"])
                refs << ref
              end
            end
          end
        end
        #only keep the references that can be matched.
        source_criteria["references"] = refs
      end

    end

    def self.get_vs_oids(source_data_criteria)
      oids = [source_data_criteria['code_list_id'], source_data_criteria['negation_code_list_id']]
      if source_data_criteria['field_values']
        recursive_field_value_oid_concat(source_data_criteria['field_values'], oids)
      end
      oids.concat source_data_criteria['value'].collect {|value| value['code_list_id']} if source_data_criteria['value']
      oids.compact.uniq
    end
    
    # This function recursively searches through a collection of field values and returns the oids associated with the
    # field values it contains. It operates recursivley in case there is ever a collection of field values that contains a collection
    #
    # @param [fields] The field values that we are going to gather the code_list_ids from
    # @param [oids] The array of oids that we will be adding to
    # @return A list of oids found within the field values
    def self.recursive_field_value_oid_concat(fields, oids)
      if fields
        # Collect oids out of collection for each value in collection that is not a collection itself
        oids.concat fields.select{|key,value| value["type"] != "COL"}.values.collect {|value| value['code_list_id']}
        # Also add oids for components
        oids.concat fields.select{|key,value| value["type"] != "COL"}.values.collect {|value| value['code_list_id_cmp']}
        # Recurse through potential inner collections adding their oids along the way
        fields.select{|key,value| value["type"] == "COL"}.values.each {
          |collection| collection["values"].each{ 
            |value| recursive_field_value_oid_concat({'VALUE'=>value}, oids)
          }
        }
      end
      oids
    end

    def self.derive_time_range(value)
      low = {'value' => Time.at(value['start_date'].to_i / 1000).utc.strftime('%Y%m%d%H%M%S'), 'type'=>'TS' } unless value['start_date'].blank?
      high = {'value' => Time.at(value['end_date'].to_i / 1000).utc.strftime('%Y%m%d%H%M%S'), 'type'=>'TS' } unless value['end_date'].blank?
      HQMF::Range.from_json({'low' => low,'high' => high})
    end


    # Determine the appropriate coded entry type from this data criteria and create one to match.
    #
    # @param [data_criteria]  The data_criteria object to create the entry for
    # @param [Range] time The period of time during which the entry happens.
    # @param [source_criteria] the hash that represents the patients sopurce_data_criteria
    # @param [Hash] oid_to_vs_hash The value sets that this data criteria references.
    # @return A coded entry with basic data defined by this data criteria.
    def self.derive_entry(data_criteria,source_criteria, oid_to_vs_hash)

      return nil if data_criteria.nil? || (data_criteria['type'] == 'characteristic' && data_criteria['patient_api_function'].nil?)
      time = derive_time_range(source_criteria)
      entry_type = HQMF::Generator.classify_entry(data_criteria['patient_api_function'].to_sym)
      entry = entry_type.classify.constantize.new
      entry.description = source_criteria["description"]
      entry.start_time = time.low.to_seconds if time.low
      entry.end_time = time.high.to_seconds if time.high
      entry.status = source_criteria['status']
      # If there are no source criteria codes, select new codes, otherwise use existing codes
      if source_criteria['codes'].blank?
        entry.codes = Measures::PatientBuilder.select_codes(source_criteria['code_list_id'], oid_to_vs_hash)
      else
        entry.codes = source_criteria['codes']
      end
      entry.oid = HQMF::DataCriteria.template_id_for_definition(source_criteria['definition'], source_criteria['status'], source_criteria['negation'])
      entry.oid ||= HQMF::DataCriteria.template_id_for_definition(source_criteria['definition'], source_criteria['status'], source_criteria['negation'], 'r2')
      entry
    end


    # derive the values for the source data criteria
    def self.derive_values(entry, values, oid_to_vs_hash)
      return if values.nil? || values.empty?
      derived = []
      result_vals = values
      result_vals = [result_vals] if !result_vals.is_a? Array
      result_vals.each do |result_value|
        if result_value['type'] == 'CD'
          oid = result_value['code_list_id']
          codes = result_value['codes'] || Measures::PatientBuilder.select_codes(oid, oid_to_vs_hash)
          vs = Measures::PatientBuilder.select_value_sets(oid, oid_to_vs_hash)
          derived << CodedResultValue.new({codes:codes, description: vs["display_name"]})
        elsif result_value['type'] == 'RT'
          if result_value['numerator_scalar'] && result_value['denominator_scalar']
            derived << RatioResultValue.new(result_value)
          end
        elsif result_value['type'] == 'TS'
          # Recycling the use of Range/PhysicalQuantity for TimeStamps
          # converts from milliseconds to seconds for use by CQL_QDM.Helpers.convertDateTime()
          time = HQMF::Range.from_json('low' => {'value' => result_value['value']/1000, 'unit' => 'UnixTime'})
          derived << PhysicalQuantityResultValue.new(time.format)
        else
          range = HQMF::Range.from_json('low' => {'value' => result_value['value'], 'unit' => result_value['unit']})
          derived << PhysicalQuantityResultValue.new(range.format)
        end
      end
      entry.values= derived
    end

    # derive the negation for the source_data_criteria entry if it is negated
    def self.derive_negation(entry,value,oid_to_vs_hash)
      if value['negation']
        codes = Measures::PatientBuilder.select_code(value['negation_code_list_id'], oid_to_vs_hash)
        entry.negation_ind = true
        entry.negation_reason = codes
      end
    end
    
    # This is the recursive helper function to the self.derive_field_values function it is recursive to support
    # field values that may contain other field values
    def self.recursive_field_value_derivation(value, oid_to_vs_hash, name, entry)
      return if value.nil?
      if value['type'] == 'TS'
        converted_time = Time.at(value['value']/1000).utc.strftime('%Y%m%d%H%M%S')
      end
      field = HQMF::DataCriteria.convert_value(value)
      field.value = converted_time if converted_time
      field_value = {}

      # Format the field to be stored in a Record.
      if field.type == "CD"
        if value["codes"]
          # Multiple codes were specified
          field_value["codes"] = value["codes"]
        elsif value["code"] && !value["code"].empty?
          # A single code was specified
          field_value = value["code"]
        else
          # No codes specified, default to first possible code
          field_value = Measures::PatientBuilder.select_code(field.code_list_id, oid_to_vs_hash)
        end
        field_value["title"] = Measures::PatientBuilder.select_value_sets(field.code_list_id, oid_to_vs_hash)["display_name"] if field_value
      elsif field.type == "CMP"
        field_value["code"] = Measures::PatientBuilder.select_code(field.code_list_id, oid_to_vs_hash)
        cmp_type = value["type_cmp"]
        field_value["result"] = {}
        if cmp_type == "TS"
          field_value["result"]["units"] = "UnixTime"
          # converts from milliseconds to seconds for use by CQL_QDM.Helpers.convertDateTime()
          field_value["result"]["scalar"] = value['value']/1000
        elsif cmp_type == "CD"
          field_value["result"]["code"] = Measures::PatientBuilder.select_code(field.code_list_id_cmp, oid_to_vs_hash)
          field_value["result"]["title"] = Measures::PatientBuilder.select_value_sets(field.code_list_id_cmp, oid_to_vs_hash)["display_name"]
        else
          field_value["result"] = {"scalar"=>value["value"], "units"=>value["unit"]}
        end

        if value["referenceRangeLow_value"]
          field_value["referenceRangeLow"] = {"scalar"=>value["referenceRangeLow_value"], "units"=>value["referenceRangeLow_unit"]}
          field_value["referenceRangeHigh"] = {"scalar"=>value["referenceRangeHigh_value"], "units"=>value["referenceRangeHigh_unit"]}
        end
      elsif field.type == "FAC"
        field_value["code"] = Measures::PatientBuilder.select_code(field.code_list_id, oid_to_vs_hash)
        field_value["display"] = field.title
        field_value["locationPeriodLow"] = value["locationPeriodLow"]
        field_value["locationPeriodHigh"] = value["locationPeriodHigh"]
      elsif field.type == "COL"
        # recurse through entry
        # recursive function should be this function that returns the derived entry
        # entry will push each derived field value to field_value
        values = []
        value["values"].each do |val| 
          # TODO name will have to be reset to name of embeded value if there are ever recursive collections or collections of mixed types
          field_val, field_acc = self.recursive_field_value_derivation(val, oid_to_vs_hash, name, entry)
          values.push field_val
        end
        field_value = {"type"=> "COL", "values" => values}
      # type is a QDM id with a value and a naming system
      elsif field.type == "ID"
        field_value["value"] = value["root"]
        field_value["namingSystem"] = value["extension"]
      else
        field_value = field.format
      end

      field_accessor = nil

      if name.include? "TRANSFER"
        if name.starts_with? "TRANSFER_FROM"
          transfer = entry.transfer_from
          field_accessor = :transfer_from
          default_time = entry.start_time
        else
          transfer = entry.transfer_to
          field_accessor = :transfer_to
          default_time = entry.end_time
        end
        transfer ||= Transfer.new

        if field.type == "CD"
          transfer = Transfer.new(transfer.attributes.merge(field_value)) unless field_value.nil?
        else
          transfer.time = field_value
        end
        transfer.time ||= default_time

        field_value = transfer
      end
      
      [field_value, field_accessor]
    end

    # Add this data criteria's field related data to a coded entry.
    # @param [Entry] entry The coded entry that this data criteria is modifying.
    # @param [Array] values An array of values to create entries for
    # @param [Hash] oid_to_vs_hash The value sets that this data criteria references.
    # @return The modified coded entry.
    def self.derive_field_values(entry, values, oid_to_vs_hash)
      return if values.nil?
      values.each do |name, value|
        field_value, field_accessor = recursive_field_value_derivation(value, oid_to_vs_hash, name, entry)
        # Add field to entry, catagorized by the QDM human readable name->coded_entry_method defined in health-data-standards/lib/hqmf-model/data_criteria.rb
        begin
          field_accessor ||= HQMF::DataCriteria::FIELDS[name][:coded_entry_method]
          entry.send("#{field_accessor}=", field_value)
        rescue
          # Give some feedback if we hit an unexpected error. Some fields have no action expected, so we'll suppress those messages.
          noop_fields = ["LENGTH_OF_STAY", "START_DATETIME", "STOP_DATETIME"]
          unless noop_fields.include? name
            field_accessor = HQMF::DataCriteria::FIELDS[name][:coded_entry_method]
            puts "Unknown field #{name} was unable to be added via #{field_accessor} to the patient"
          end
        end
      end
    end


     # Select the relevant value set that matches the given OID and generate a hash that can be stored on a Record.
    # The hash will be of this format: { "code_set_identified" => [code] }
    #
    # @param [String] oid The target value set.
    # @param [Hash] oid_to_vs_hash Value sets that might contain the OID for which we're searching.
    # @return A Hash of code sets corresponding to the given oid, each containing one randomly selected code.
    def self.select_codes(oid, oid_to_vs_hash)
      default_code_sets = {}
      listed_sets = {}
      vs = oid_to_vs_hash[oid]
      vs.concepts.each do |concept|
        default_code_sets[concept.code_system_name] ||= [concept.code]
      end if vs
      (listed_sets.empty? ? default_code_sets : listed_sets)
    end


    # Filter through a list of value sets and choose only the ones marked with a given OID.
    #
    # @param [String] oid The OID being used for filtering.
    # @param [Array] oid_to_vs_hash A pool of available value sets
    # @return The value set from the list with the requested OID.
    def self.select_value_sets(oid, oid_to_vs_hash)
      # Pick the value set for this DataCriteria. If it can't be found, it is an error from the value set source. We'll add the entry without codes for now.
      vs = oid_to_vs_hash[oid]
      vs = vs || CQM::ValueSet.new(concepts: [])
      vs
    end

    # Select the relevant value set that matches the given OID and generate a hash that can be stored on a Record.
    # The hash will be of this format: { "codeSystem" => "code_set_identified", "code" => code }
    #
    # @param [String] oid The target value set.
    # @param [Hash] oid_to_vs_hash Value sets that might contain the OID for which we're searching.
    # @return A Hash including a code and code system containing one randomly selected code.
    def self.select_code(oid, oid_to_vs_hash)
      codes = select_codes(oid, oid_to_vs_hash)
      code_system = codes.keys[0]
      return nil if code_system.nil?
      {
        code_system: code_system,
        code: codes[code_system][0]
      }
    end

  end
end
