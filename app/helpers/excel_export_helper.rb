require 'cgi'

module ExcelExportHelper
  # Excel export only needs the statment_results and criteria, so extract them from the results object.
  #
  # The return will have this form:
  # calc_results = {
  #   'population_index' : {
  #     'patient_id' : {
  #       'statement_results' :  {
  #         'libraryName' : {
  #           'statement1' : '<statement result>',
  #           'statement2' : '<statement result>',
  #           ...other statements...
  #         }
  #       'criteria' : {'IPP' : <result>, ...other criteria...}
  #       }
  #     },
  #     ...other patients...
  #   },
  #   ...other populations...
  # }
  def self.convert_results_for_excel_export(results, measure, patients)
    calc_results = ActiveSupport::HashWithIndifferentAccess.new
    measure.population_sets.each_with_index do |population, index|
      patients.each do |patient|
        calc_results[index] = {} unless calc_results[index]
        result = results[patient.id.to_s]
        if result.nil?
          # if there was no result for a patient (due to error in conversion or calculation), set empty results
          calc_results[index][patient.id.to_s] = {statement_results: {}, criteria: {}}
        else
          result_criteria = {
            'values' => []
          }

          result[population.population_set_id]['extendedData']['population_relevance'].each_key do |population_criteria|
            if population_criteria == 'values'
              # Values are stored for each episode separately, so we need to gather the values from the episode_results object.
              result[population.population_set_id]['episode_results']&.each_value do |episode|
                result_criteria['values'].concat episode['values']
              end
              result_criteria['values'].sort!
            else
              result_criteria[population_criteria] = result[population.population_set_id][population_criteria]
            end
          end
          calc_results[index][patient.id.to_s] = {statement_results: extract_pretty_or_final_results(result[population.population_set_id]['statement_results']), criteria: result_criteria}
        end
      end
    end

    calc_results
  end

  # Extract the fields from the patients that are used in the exported excel file. Ignore unused fields.
  def self.get_patient_details(patients)
    patient_details = ActiveSupport::HashWithIndifferentAccess.new
    patients.each do |patient|
      next if patient_details[patient.id.to_s]
      expected_values = patient.expected_values
      expected_values.each do |ev|
        ev["OBSERV"] = [] if !ev.key?("OBSERV") || ev["OBSERV"].nil?
      end
      patient_details[patient.id.to_s] = {
        first: patient.first,
        last: patient.last,
        expected_values: expected_values,
        birthdate: patient.birthdate,
        expired: patient.expired,
        deathdate: patient.deathdate,
        ethnicity: patient.ethnicity['code'],
        race: patient.race['code'],
        gender: patient.gender,
        notes: patient.notes
      }
    end
    patient_details
  end

  # For each population, return the title, statement relevance map, and criteria list.
  # title is the title of the population, e.g. 'Population Criteria Section' or 'Stratification 1'
  # statement relevance map has the form:
  # { "libraryName1" : { "statement1" : "<NA/TRUE/FALSE>", ...}, ...}
  # criteria is an array of criteria names, e.g. ["IPP", "DENOM", "DENEX"]
  def self.get_population_details_from_measure(measure, results)
    population_details = ActiveSupport::HashWithIndifferentAccess.new
    return population_details if results.empty?

    measure.population_sets.each_with_index do |population_set, pop_index|
      # Populates the population details
      next if population_details[pop_index]

      # the population_details are independent of patient, so index into the first patient in the results.
      population_details[pop_index] = {title: population_set[:title], statement_relevance: results.first[1][population_set.population_set_id]['extendedData']['statement_relevance']}

      criteria = []
      # TODO: The front end adds 'index' to this array, but it might be unused. Investigate and remove if possible.
      criteria.push 'index'
      population_details[pop_index][:criteria] = population_set.populations.as_json.keys & CQM::Measure::ALL_POPULATION_CODES
    end

    population_details
  end

  # Builds a map of define statement name to the statement's text from a measure.
  def self.get_statement_details_from_measure(measure)
    statement_details = ActiveSupport::HashWithIndifferentAccess.new

    measure.cql_libraries.each do |library|
      lib_statements = {}
      library.elm_annotations['statements'].each do |statement|
        lib_statements[statement['define_name']] = parse_annotation_tree(statement['children'])
      end
      statement_details[library.library_name] = lib_statements
    end

    statement_details
  end

  # Recursive function that parses an annotation tree to extract text statements.
  private_class_method def self.parse_annotation_tree(children)
    ret = ""
    if children.is_a?(Array)
      children.each do |child|
        ret += parse_annotation_tree(child)
      end
    else
      return CGI.unescape_html(children['text']).sub("&#13", "").sub(";", "") if children['text']
      children['children']&.each do |child|
        ret += parse_annotation_tree(child)
      end
    end
    ret
  end

  # The result initially has a raw, final, and pretty component. Excel export only wants the pretty form, but
  # falls back to final if pretty doesn't exist on the object. Raw results are discarded.
  private_class_method def self.extract_pretty_or_final_results(results)
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
end
