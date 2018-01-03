class MeasureExportedResults

  def initialize(patient_id, population_index, results)
    @results = results
    @patient = match_patient_to_patient_id(patient_id, population_index)
  end

  def match_patient_to_patient_id(patient_id, population_index)
    patients = @results[population_index.to_s]
    # Iterate over each of the patients to match the patient_id
    patients.map{ |key, value| value if value[:patient_id] == patient_id }.compact.try(:first)
  end

  def value_for_population_type(population_type)
    if population_type == 'OBSERV'
      # TODO the check for the 'OBSERV' key was removed in order for patients that were in a broken state
      # to match between the excel export and Bonnie to address BONNIE-1230.
      # If those patients can be fixed in the future, that check should be re-integrated.

      # if @patient.key?('values') && @patient[:rationale].key?('OBSERV') && @patient[:values] != ''
      if @patient.key?('values') && @patient[:values] != ''
        # Convert the array of strings to an array of integers. 
        return @patient[:values].map { |x| x.to_i }.to_s
      else
        return 0
      end
    end
    @patient[population_type]
  end

  def get_criteria_value(criteria_key, population_type)
    value = @patient[:rationale][criteria_key]
    # value could be true, false, or nil.
    if value != nil && value != "false"
      value = "TRUE"
    elsif value == "false"
      value = "FALSE"
    end

    # Change value if specific rationale is involved. 
    if @patient[:specificsRationale] && @patient[:specificsRationale][population_type] 
      specific_value = @patient[:specificsRationale][population_type][criteria_key]
      
      # value could be "false", nil, "true"
      if specific_value == "false" && value == "TRUE"
        value = "SPECIFICALLY FALSE"
      elsif specific_value == "true" && value == "FALSE"
        value = "SPECIFICALLY TRUE"
      end
    end

    return value
  end
end