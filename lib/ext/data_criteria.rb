module HQMF
  class DataCriteria
    attr_accessor :values

    # Modify a Record with this data criteria.
    #
    # @param [Record] patient The Record that is being modified. 
    # @param [Range] time The period of time during which the data criteria happens.
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return The modified patient.
    def modify_patient(patient, time, value_sets)
      # Modify the patient with a characteristic if this data criteria defines one
      modify_patient_with_characteristic(patient, time, value_sets)

      # Otherwise we're dealing with a data criteria that describes a coded entry, so we create it and add it to the patient
      entry = derive_entry(time, value_sets)
      modify_entry_with_values(entry, value_sets)
      modify_entry_with_negation(entry, value_sets)
      modify_entry_with_fields(entry, value_sets)
      modify_patient_with_entry(patient, entry)
    end

    private

    # Modify a Record with a data criteria that describes a patient characteristic.
    #
    # @param [Record] patient The Record that is being modified. 
    # @param [Range] time The period of time during which the data criteria happens.
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return The modified patient.
    def modify_patient_with_characteristic(patient, time, value_sets)
      return nil unless characteristic?

      if property == :birthtime
        patient.birthdate = time.low.to_seconds
      elsif property == :gender
        gender = value.code
        patient.gender = gender
        patient.first = Randomizer.randomize_first_name(gender)
      elsif property == :clinicalTrialParticipant
        patient.clinicalTrialParticipant = true
      elsif property == :expired
        patient.expired = true
        patient.deathdate = time.high.to_seconds
      end
    end

    # Determine the apporpriate coded entry type from this data criteria and create one to match.
    #
    # @param [Range] time The period of time during which the entry happens.
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return A coded entry with basic data defined by this data criteria.
    def derive_entry(time, value_sets)
      return nil if characteristic?

      entry_type = Generator.classify_entry(patient_api_function)
      entry = entry_type.classify.constantize.new
      entry.description = "#{description} (Code List: #{code_list_id})"
      entry.start_time = time.low.to_seconds if time.low
      entry.end_time = time.high.to_seconds if time.high
      entry.status = status
      entry.codes = Coded.select_codes(code_list_id, value_sets)
      entry.oid = HQMF::DataCriteria.template_id_for_definition(definition, status, negation)
      entry
    end

    # Add any value related data to a coded entry from this data criteria.
    #
    # @param [Entry] entry The coded entry that this data criteria is defining.
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return The modified coded entry.
    def modify_entry_with_values(entry, value_sets)
      return nil unless entry.present? && values.present?

      # If the value itself has a code, it will be a Coded type. Otherwise, it's just a regular value with a unit.
      entry.values ||= []
      values.each do |value|
        if value.type == "CD"
          entry.values << CodedResultValue.new({codes: Coded.select_codes(value.code_list_id, value_sets), description: HQMF::Coded.select_value_sets(value.code_list_id, value_sets)["display_name"]})
        else
          entry.values << PhysicalQuantityResultValue.new(value.format)
        end
      end
    end

    # Mark a coded entry as negated if this data criteria describes it as such.
    #
    # @param [Entry] entry The coded entry that this data criteria is potentially negating.
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return The modified coded entry.
    def modify_entry_with_negation(entry, value_sets)
      return nil unless entry.present? && negation && negation_code_list_id.present?
      
      entry.negation_ind = true
      entry.negation_reason = Coded.select_code(negation_code_list_id, value_sets)
    end

    # Add this data criteria's field related data to a coded entry.
    #
    # @param [Entry] entry The coded entry that this data criteria is modifying.
    # @param [Hash] value_sets The value sets that this data criteria references.
    # @return The modified coded entry.
    def modify_entry_with_fields(entry, value_sets)
      return nil unless entry.present? && field_values.present?

      field_values.each do |name, field|
        next if field.nil?

        # Format the field to be stored in a Record.
        if field.type == "CD"
          field_value = Coded.select_code(field.code_list_id, value_sets)
          field_value["title"] = HQMF::Coded.select_value_sets(field.code_list_id, value_sets)["display_name"] if field_value
        else
          field_value = field.format
        end
        
        field_accessor = nil
        # Facilities are a special case where we store a whole object on the entry in Record. Create or augment the existing facility with this piece of data.
        if name.include? "FACILITY"
          facility = entry.facility
          facility ||= Facility.new
          facility_map = {"FACILITY_LOCATION" => :code, "FACILITY_LOCATION_ARRIVAL_DATETIME" => :start_time, "FACILITY_LOCATION_DEPARTURE_DATETIME" => :end_time}
          
          facility.name = field.title if type == "CD"
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

    # Add a coded entry to a patient.
    #
    # @param [Record] patient The coded entry that this data criteria is potentially negating.
    # @param [Entry] entry The value sets that this data criteria references.
    # @return The modified patient.
    def modify_patient_with_entry(patient, entry)
      return patient if entry.nil?

      # Figure out which section this entry will be added to. Some entry names don't map prettily to section names.
      entry_type = Generator.classify_entry(patient_api_function)
      section_map = { "lab_results" => "results" }
      section_name = section_map[entry_type]
      section_name ||= entry_type

      # Add the updated section to this patient.
      section = patient.send(section_name)
      section.push(entry)
      
      patient
    end

    def characteristic?
      type == :characteristic && patient_api_function.nil? ? true : false
    end
  end
end