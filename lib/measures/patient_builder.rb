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
      WHITE_LIST: 'WHITE_LIST',
      USER_DEFINED: 'USER_DEFINED'
    }

    def self.rebuild_patient(patient)

      patient.medical_record_number ||= Digest::MD5.hexdigest("#{patient.first} #{patient.last} #{Time.now}")
      vs_oids = patient.source_data_criteria.collect{|dc| get_vs_oids(dc)}.flatten.uniq

      value_sets =  Hash[*HealthDataStandards::SVS::ValueSet.in({oid: vs_oids, user_id: patient.user_id}).collect{|vs| [vs.oid,vs]}.flatten]
      sections = {}
      patient.source_data_criteria.each  do |source_criteria|
        next if source_criteria['id'] == 'MeasurePeriod'
        data_criteria = nil
        begin
          data_criteria = HQMF::DataCriteria.get_settings_for_definition(source_criteria['definition'], source_criteria['status'])
        rescue
          #unsupported data criteria.
          puts $!
        end
        entry = Measures::PatientBuilder.derive_entry(data_criteria, source_criteria, value_sets)
        # if its a thing like result, condition, encounter it will have an entry otherwise
        # its most likely a characteristic
        if entry
          derive_values(entry, source_criteria['value'] ,value_sets)
          derive_negation(entry, source_criteria, value_sets)
          derive_field_values(entry, source_criteria['field_values'],value_sets)

          entry_type = HQMF::Generator.classify_entry(data_criteria['patient_api_function'].to_sym)
          section_name = (entry_type == "lab_results") ? "results" : entry_type

          source_criteria['coded_entry_id'] = entry.id

          source_criteria['codes'] = entry['codes']
          if source_criteria['code_source'] != Measures::PatientBuilder::CODE_SOURCE[:USER_DEFINED]
            source_criteria['code_source'] = if Measures::PatientBuilder.white_list?(source_criteria['code_list_id'], value_sets)
              Measures::PatientBuilder::CODE_SOURCE[:WHITE_LIST]
            else
              Measures::PatientBuilder::CODE_SOURCE[:DEFAULT]
            end
          end

          if section_name == "medications"
             fulfillments = []
            if !source_criteria[:dose_value].blank? && !source_criteria[:dose_unit].blank?
              entry[:dose] = { "value" => source_criteria[:dose_value], "unit" => source_criteria[:dose_unit] }
            end
            if !source_criteria[:frequency_value].blank? && !source_criteria[:frequency_unit].blank?
              entry[:administrationTiming] = { "period" => { "value" => source_criteria[:frequency_value], "unit" => source_criteria[:frequency_unit] } }
             end
             if !source_criteria[:fulfillments].blank?
               source_criteria[:fulfillments].each do |fulfillment|
                 fulfillments.push(FulfillmentHistory.new({:dispenseDate => fulfillment[:dispense_datetime], :quantityDispensed => {:value => fulfillment[:quantity_dispensed_value], :unit => fulfillment[:quantity_dispensed_unit]}}))
               end
             end
             entry[:fulfillmentHistory] = fulfillments
          end

          # Add the updated section to this patient.
          sections[section_name] ||= []
          sections[section_name].push(entry)
        end
      end
      # if the patient is persisted, monoid will send the updates at this point.
      Record::Sections.each do |section|
        patient.send(section).clear.concat(sections[section.to_s] || [])
      end

    end

    def self.get_vs_oids(source_data_criteria)
      oids = [source_data_criteria['code_list_id'], source_data_criteria['negation_code_list_id']]
      oids.concat source_data_criteria['field_values'].values.collect {|field| field['code_list_id']} if source_data_criteria['field_values']
      oids.concat source_data_criteria['value'].collect {|value| value['code_list_id']} if source_data_criteria['value']
      oids.compact.uniq
    end

    def self.derive_time_range(value)
      low = {'value' => Time.at(value['start_date'].to_i / 1000).utc.strftime('%Y%m%d%H%M%S'), 'type'=>'TS' } unless value['start_date'].blank?
      high = {'value' => Time.at(value['end_date'].to_i / 1000).utc.strftime('%Y%m%d%H%M%S'), 'type'=>'TS' } unless value['end_date'].blank?
      HQMF::Range.from_json({'low' => low,'high' => high})
    end



    # Determine the apporpriate coded entry type from this data criteria and create one to match.
    #
    # @param [data_criteria]  The data_criteria object to create the entry for
    # @param [Range] time The period of time during which the entry happens.
    # @param [source_criteria] the hash that represents the patients sopurce_data_criteria
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return A coded entry with basic data defined by this data criteria.
    def self.derive_entry(data_criteria,source_criteria, value_sets)

      return nil if data_criteria.nil? || (data_criteria['type'] == 'characteristic' && data_criteria['patient_api_function'].nil?)
      time = derive_time_range(source_criteria)
      entry_type = HQMF::Generator.classify_entry(data_criteria['patient_api_function'].to_sym)
      entry = entry_type.classify.constantize.new
      entry.description = source_criteria["description"]
      entry.start_time = time.low.to_seconds if time.low
      entry.end_time = time.high.to_seconds if time.high
      entry.status = source_criteria['status']
      if (source_criteria['code_source'] == Measures::PatientBuilder::CODE_SOURCE[:USER_DEFINED])
        entry.codes = source_criteria['codes']
      else
        entry.codes = Measures::PatientBuilder.select_codes(source_criteria['code_list_id'], value_sets)
      end
      entry.oid = HQMF::DataCriteria.template_id_for_definition(source_criteria['definition'], source_criteria['status'], source_criteria['negation'])
      entry
    end


    # derive the values for the source data criteira
    def self.derive_values(entry, values, value_sets)
      return if values.nil? || values.empty?
      derived = []
      result_vals = values
      result_vals = [result_vals] if !result_vals.is_a? Array
      result_vals.each do |result_value|
        if result_value['type'] == 'CD'
         oid = result_value['code_list_id']
         codes = result_value['codes'] || Measures::PatientBuilder.select_codes(oid, value_sets)
         vs = Measures::PatientBuilder.select_value_sets(oid, value_sets)
         derived << CodedResultValue.new({codes:codes, description: vs["display_name"]})
        else
          range = HQMF::Range.from_json('low' => {'value' => result_value['value'], 'unit' => result_value['unit']})
          derived << PhysicalQuantityResultValue.new(range.format)
        end
      end
      entry.values= derived
    end

    # derive the negation for the source_data_criteria entry if it is negated
    def self.derive_negation(entry,value,value_sets)
      if value['negation']
          codes = value["negation_code"] || Measures::PatientBuilder.select_code(value['negation_code_list_id'], value_sets)
          entry.negation_ind = true
          entry.negation_reason = codes
        end
    end

    # Add this data criteria's field related data to a coded entry.
    #
    # @param [Entry] entry The coded entry that this data criteria is modifying.
    # @param [Array] values An array of values to create entries for
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return The modified coded entry.
    def self.derive_field_values(entry, values, value_sets)
      return if values.nil?
      values.each do |name, value|

        converted_time = Time.at(value['value']/1000).utc.strftime('%Y%m%d%H%M%S') if (value['type'] == 'TS')
        field = HQMF::DataCriteria.convert_value(value)
        field.value = converted_time if converted_time

        # Format the field to be stored in a Record.
        if field.type == "CD"
          field_value = value["code"] || Measures::PatientBuilder.select_code(field.code_list_id, value_sets)
          field_value["title"] = Measures::PatientBuilder.select_value_sets(field.code_list_id, value_sets)["display_name"] if field_value
        else
          field_value = field.format
        end

        field_accessor = nil
        # Facilities are a special case where we store a whole object on the entry in Record. Create or augment the existing facility with this piece of data.
        if name.include? "FACILITY"
          facility = entry.facility
          facility ||= Facility.new
          facility_map = {"FACILITY_LOCATION" => :code, "FACILITY_LOCATION_ARRIVAL_DATETIME" => :start_time, "FACILITY_LOCATION_DEPARTURE_DATETIME" => :end_time}

          facility.name = field.title if field.type == "CD"
          facility_accessor = facility_map[name]
          facility.send("#{facility_accessor}=", field_value)

          field_accessor = :facility
          field_value = facility
        end

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
            transfer = Transfer.new(transfer.attributes.merge(field_value))
          else
            transfer.time = field_value
          end
          transfer.time ||= default_time

          field_value = transfer
        end

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
    # @param [Hash] value_sets Value sets that might contain the OID for which we're searching.
    # @return A Hash of code sets corresponding to the given oid, each containing one randomly selected code.
    def self.select_codes(oid, value_sets)
      default_code_sets = {}
      listed_sets = {}
      vs = value_sets[oid]
      vs.concepts.each do |concept|
        default_code_sets[concept.code_system_name] ||= [concept.code] unless concept.black_list
        listed_sets[concept.code_system_name] ||= [concept.code] if concept.white_list
      end if vs
      (listed_sets.empty? ? default_code_sets : listed_sets)
    end

    def self.white_list?(oid, value_sets)
      if value_sets[oid]
        value_sets[oid].concepts.any? {|x| x.white_list}
      end
    end


    # Filter through a list of value sets and choose only the ones marked with a given OID.
    #
    # @param [String] oid The OID being used for filtering.
    # @param [Array] value_sets A pool of available value sets
    # @return The value set from the list with the requested OID.
    def self.select_value_sets(oid, value_sets)
      # Pick the value set for this DataCriteria. If it can't be found, it is an error from the value set source. We'll add the entry without codes for now.
      vs = value_sets[oid]
      vs = vs || HealthDataStandards::SVS::ValueSet.new({ "concepts" => [] })
      vs
    end

    # Select the relevant value set that matches the given OID and generate a hash that can be stored on a Record.
    # The hash will be of this format: { "codeSystem" => "code_set_identified", "code" => code }
    #
    # @param [String] oid The target value set.
    # @param [Hash] value_sets Value sets that might contain the OID for which we're searching.
    # @return A Hash including a code and code system containing one randomly selected code.
    def self.select_code(oid, value_sets)
      codes = select_codes(oid, value_sets)
      code_system = codes.keys[0]
      return nil if code_system.nil?
      {
        'code_system' => code_system,
        'code' => codes[code_system][0]
      }
    end

  end
end
