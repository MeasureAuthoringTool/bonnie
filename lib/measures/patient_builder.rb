module Measures
  # Utility class for building test patients
  class PatientBuilder
    JAN_ONE_THREE_THOUSAND=32503698000000
  

    def self.rebuild_patient(patient)

      # clear out patient data
      if (patient.id)
        Record::Sections.each do |section|
          patient.method(section).call.delete_all
        end
      end
      patient.medical_record_number ||= Digest::MD5.hexdigest("#{patient.first} #{patient.last}")

      value_sets = get_value_sets(patient['measure_ids'] || [], patient.user).values
      measure_data_criteria = get_data_criteria(patient['measure_ids'] || [], patient.user)
      
      patient.source_data_criteria.each  do |v|
        next if v['id'] == 'MeasurePeriod'

        data_criteria = HQMF::DataCriteria.from_json(v['id'], measure_data_criteria[v['id']])
        entry = Measures::PatientBuilder.derive_entry(data_criteria, v, value_sets)
        # if its a thing like result, condition, encounter it will have an entry otherwise 
        # its most likely a characteristic
        if entry
          derive_values(entry, v['values'] ,value_sets)
          derive_negation(entry, v, value_sets)
          derive_field_values(entry, v['field_values'],value_sets)
         
          entry_type = HQMF::Generator.classify_entry(data_criteria.patient_api_function)
          section_name = (entry_type == "lab_results") ? "results" : entry_type

          # Add the updated section to this patient.
          section = patient.send(section_name)
          section.push(entry)
        end
      end
    end


   

    def self.derive_time_range(value)
      low = {'value' => Time.at(value['start_date'].to_i / 1000).strftime('%Y%m%d%H%M%S'), 'type'=>'TS' }
      high = {'value' => Time.at(value['end_date'].to_i / 1000).strftime('%Y%m%d%H%M%S'), 'type'=>'TS' }
      high = nil if value['end_date'] == JAN_ONE_THREE_THOUSAND
      HQMF::Range.from_json({'low' => low,'high' => high})
    end

    # get all of the data criteria for the set of measures passed in
    def self.get_data_criteria(measure_list, current_user)
      Hash[
        *Measure.by_user(current_user).where({'hqmf_set_id' => {'$in' => measure_list}}).map{|m|
          m.source_data_criteria.reject{|k,v|
            ['patient_characteristic_birthdate','patient_characteristic_gender', 'patient_characteristic_expired'].include?(v['definition'])
          }.each{|k,v|
            v['title'] += ' (' + m.measure_id + ')'
          }
        }.map(&:to_a).flatten
      ]
    end

    def self.missing_data_criteria(record, data_criteria)
      record.source_data_criteria.select {|e| data_criteria[e['id']].nil? && e['id'] != 'MeasurePeriod' }
    end

    def self.check_data_criteria!(record, data_criteria)
      dropped_data_criteria = []
      if (record.respond_to? :source_data_criteria)
        # check to see if there are any data criteria that we cannot find.  If there are, we want to remove them.
        dropped_source_criteria = Measures::PatientBuilder.missing_data_criteria(record, data_criteria)
        dropped_source_criteria.each do |dc|
          alternates = data_criteria.select {|key,value| value['code_list_id'] == dc['oid'] && value['status'] == dc['status'] && value['definition'] == dc['definition'] }.keys
          if (!alternates.empty?)
            alternate = (alternates.sort {|left, right| Text::Levenshtein.distance(left, dc['id']) <=> Text::Levenshtein.distance(right, dc['id'])}).first
            # update the source data criteria to set the alternate id with the closes id and a matching code set id
            puts "\talternate: #{alternate} for #{dc['id']}"
            dc['id'] = alternate
          end
        end

        dropped_ids = Measures::PatientBuilder.missing_data_criteria(record, data_criteria).map {|dc| dc['id'] }

        record.source_data_criteria.delete_if {|dc| dropped = dropped_ids.include? dc['id']; dropped_data_criteria << dc if dropped; dropped}
        
      end
      dropped_data_criteria
    end



    # Determine the apporpriate coded entry type from this data criteria and create one to match.
    #
    # @param [data_criteria]  The data_criteria object to create the entry for
    # @param [Range] time The period of time during which the entry happens.
    # @param [value] the hash that represents the patients sopurce_data_criteria
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return A coded entry with basic data defined by this data criteria.
    def self.derive_entry(data_criteria,value, value_sets)
      return nil if data_criteria.type == :characteristic && data_criteria.patient_api_function.nil? 
      time = derive_time_range(value)
      data_criteria.negation = value["negation"] == "true" || value["negation"]
      data_criteria.negation_code_list_id = value["negation_code_list_id"]
      entry_type = HQMF::Generator.classify_entry(data_criteria.patient_api_function)
      entry = entry_type.classify.constantize.new
      entry.description = value["description"] || "#{data_criteria.description} (Code List: #{data_criteria.code_list_id})"
      entry.start_time = time.low.to_seconds if time.low
      entry.end_time = time.high.to_seconds if time.high
      entry.status = data_criteria.status
      entry.codes = value["codes"] || Measures::PatientBuilder.select_codes(data_criteria.code_list_id, value_sets)
      entry.oid = HQMF::DataCriteria.template_id_for_definition(data_criteria.definition, data_criteria.status, data_criteria.negation)
      entry
    end


    # derive the values for the source data criteira
    def self.derive_values(entry, values, value_sets)
      return if values.nil?
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
      if value['negation'] == 'true' || value['negation']
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
        converted_time = Time.strptime(value['value'],"%m/%d/%Y %H:%M").to_time.strftime('%Y%m%d%H%M%S') if (value['type'] == 'TS') 
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
      vs = Measures::PatientBuilder.select_value_sets(oid, value_sets)
      code_sets = {}
      vs["concepts"].each do |concept|
        code_sets[concept["code_system_name"]] ||= [concept["code"]]
      end
      code_sets
    end
    
    # Filter through a list of value sets and choose only the ones marked with a given OID.
    #
    # @param [String] oid The OID being used for filtering.
    # @param [Array] value_sets A pool of available value sets
    # @return The value set from the list with the requested OID.
    def self.select_value_sets(oid, value_sets)
      # Pick the value set for this DataCriteria. If it can't be found, it is an error from the value set source. We'll add the entry without codes for now.
      index = value_sets.index{|value_set| value_set["oid"] == oid}
      vs = index.nil? ? { "concepts" => [] } : value_sets[index]
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
      code_system = codes.keys()[0]
      return nil if code_system.nil?
      {
        'code_system' => code_system,
        'code' => codes[code_system][0]
      }
    end

    # Get a mapping of the valuesets for the selected measures
    def self.get_value_sets(measure_list, current_user)
      Hash[
        *Measure.by_user(current_user).where({'hqmf_set_id' => {'$in' => measure_list}}).map{|m|
          m.value_sets.map do |value_set|
            preferred_set = nil
            filtered = HealthDataStandards::SVS::ValueSet.new(value_set.attributes)
            filtered.concepts.reject! {|c| c.black_list || !c.white_list}
            filtered['concepts'] = filtered.concepts
            preferred_set = filtered unless filtered.concepts.empty?
            preferred_set ||= value_set
            [value_set.oid, preferred_set]
          end
        }.map(&:to_a).flatten
      ]
    end
  end
end
