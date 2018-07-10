require 'uri'

module ExcelExportHelper
  def self.convert_results_for_excel_export(results, measure, patients)
    # Convert results from the back-end calculator to the format expected the excel export module

    calc_results = {}
    measure.populations.each_with_index do |population, index|
      patients.each do |patient|
        calc_results[index] = {} unless calc_results[index]
        result_criteria = {}
        result = results[patient.id]
        result[population['id']]['extendedData']['population_relevance'].each_key do |pop_crit|
          if pop_crit == 'values'
            values = []
            # gather the values from the episode_results object.
            result[population['id']]['episode_results'].each_value do |episode|
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

    calc_results.with_indifferent_access
  end

  private_class_method def self.remove_extra(results)
    ret = {}
    results.each_key do |lib_key|
      ret[lib_key] = {}
      results[lib_key].each_key do |statement_key|
        ret[lib_key][statement_key] = if results[lib_key][statement_key]['pretty']
                                        results[lib_key][statement_key]['pretty']
                                      else
                                        results[lib_key][statement_key]['final']
                                      end
      end
    end
    ret
  end

  def self.get_patient_details(patients)
    patient_details = {}
    patients.each do |patient|
      next unless patient_details[patient.id]
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
    patient_details.with_indifferent_access
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
      criteria.push 'index'
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
        lib_statements[statement['define_name']] = parse_annotation_tree(statement['children'])
      end
      statement_details[library_name] = lib_statements
    end

    statement_details.with_indifferent_access
  end

  private_class_method def self.parse_annotation_tree(children)
    # Recursive function that parses an annotation tree to extract text statements.
    ret = ""
    if children.is_a?(Array)
      children.each do |child|
        ret += parse_annotation_tree(child)
      end
    else
      return URI.decode_www_form(children['text']).join.sub("&#13", "").sub(";", "") if children['text']
      children['children']&.each do |child|
        ret += parse_annotation_tree(child)
      end
    end
    ret
  end
end
