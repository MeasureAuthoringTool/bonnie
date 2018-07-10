require 'uri'

module ExcelExportHelper
  def self.convert_results_for_excel_export(results, measure, patients)
    # Convert results from the back-end calculator to the format
    # expected the excel export module

    calc_results = {}
    measure.populations.each_with_index do | population, index |
      patients.each do | patient |
        if !calc_results[index]
          calc_results[index] = {}
        end
        result_criteria = {}
        result = results[patient.id]
        result[population['id']]['extendedData']['population_relevance'].keys.each do |pop_crit|
          if pop_crit == 'values'
            values = []
            # gather the values from the episode_results object.
            result[population['id']]['episode_results'].each do | index, episode |
              values.concat episode['values']
            end
            result_criteria[pop_crit] = values
          else
            result_criteria[pop_crit] = result[population['id']][pop_crit]
          end
        end
        calc_results[index][patient.id] = {statement_results: remove_extra(result[population['id']]['statement_results']), criteria: result_criteria}

      end
    end

    return calc_results.with_indifferent_access
  end

  private_class_method def self.remove_extra(results)
    ret = {}
    results.each_key do |libKey|
      ret[libKey] = {}
      results[libKey].each_key do |statementKey|
        if results[libKey][statementKey]['pretty']
          ret[libKey][statementKey] = results[libKey][statementKey]['pretty']
        else
          ret[libKey][statementKey] = results[libKey][statementKey]['final']
        end
      end
    end
    return ret
  end

  def self.get_patient_details(patients)
    patient_details = {}
    patients.each do | patient |
      if !patient_details[patient.id]
        patient_details[patient.id] = {
          first: patient.first,
          last: patient.last,
          expected_values: patient.expected_values,
          birthdate: patient.birthdate,
          expired: patient.expired,
          deathdate: patient.deathdate,
          ethnicity: patient.ethnicity['code'],
          race: patient.race['code'],
          gender: patient.gender,
          notes: patient.notes
        }
      end
    end
    return patient_details.with_indifferent_access
  end

  def self.get_population_details_from_measure(measure, results)
    population_details = {}

    measure.populations.each_with_index do |population, pop_index|
      # Populates the population details
      next if population_details[pop_index]

      # the population_details are independent of patient, so index into the first patient in the results.
      population_details[pop_index] = {title: population[:title], statement_relevance: results.first[1][population['id']]['extendedData']['statement_relevance']}

      criteria = []
      population.each_key do |key|
        criteria << key if key != "title" && key != "sub_id" && key != "id"
      end
      population_details[pop_index][:criteria] = criteria
    end

    population_details.with_indifferent_access
  end

  def self.get_statement_details_from_measure(measure)
    # Builds a map of define statement name to the statement's text from a measure.
    statement_details = {}

    measure.elm_annotations.each do |library_name, library|
      lib_statements = {}
      library['statements'].each do |statement|
        lib_statements[statement['define_name']] = parseAnnotationTree(statement['children'])
      end
      statement_details[library_name] = lib_statements
    end

    return statement_details.with_indifferent_access
  end

  private_class_method def self.parseAnnotationTree(children)
    # Recursive function that parses an annotation tree to extract text statements.
    ret = ""
    if children.is_a?(Array)
      children.each do |child|
        ret = ret + parseAnnotationTree(child)
      end
    else
      if children['text']
        return URI.unescape(children['text']).sub("&#13", "").sub(";", "")
      end

      if children['children']
        children['children'].each do |child|
          ret = ret + parseAnnotationTree(child)
        end
      end
    end

    return ret
  end

end
