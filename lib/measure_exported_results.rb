class MeasureExportedResults

  def initialize(patient_id, population_index, results)
    @results = results
    @patient = match_patient_to_patient_id(patient_id, population_index)
  end

  def match_patient_to_patient_id(patient_id, population_index)
    patients = @results[population_index.to_s]
    #Iterate over each of the patients to match the patient_id
    patients.map{ |key, value| value if value['patient_id'] == patient_id }.compact.try(:first)
  end

  def value_for_population_type(population_type)
    if population_type == 'OBSERV'
      if @patient.key?('values') && @patient['rationale'].key?('OBSERV')
        #Use eval to remove quotes around numbers ['75'] -> [75] 
        return eval @patient['values'].to_s.gsub('"', '')
      else
        return 0
      end
    end
  	@patient[population_type]
  end

  def get_criteria_value(criteria_key, population_type)
    value = @patient['rationale'][criteria_key]
    #Change value if specific rationale is involved.
    if @patient.key?('specificsRationale')
      if @patient['specificsRationale'].key?(population_type)
        value = @patient['specificsRationale'][population_type][criteria_key]
      end
    end
    if value == "false"
      return false
    else
      return value
    end
  end
end