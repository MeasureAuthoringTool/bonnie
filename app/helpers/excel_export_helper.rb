require 'uri'

module ExcelExportHelper
  def self.convert_results_for_excel_export(results)
    # Convert results from the back-end calculator to the format
    # expected the excel export module

    results_for_excel_export = {}
    # TODO: do conversion here

    ####################################################################################
    # These are snippets from the existing conversion in measure_view.js.coffee
    ####################################################################################
    # for pop in @model.get('populations').models
    #   for patient in @model.get('patients').models
    #     if calc_results[pop.cid] == undefined
    #       calc_results[pop.cid] = {}
    #     # Re-calculate results before excel export (we need to include pretty result generation)
    #     bonnie.calculator_selector.clearResult pop, patient
    #     result = pop.calculate(patient, {doPretty: true})
    #     result_criteria = {}
    #     for pop_crit of result.get('population_relevance')
    #       result_criteria[pop_crit] = result.get(pop_crit)
    #     calc_results[pop.cid][patient.cid] = {statement_results: @removeExtra(result.get("statement_results")), criteria: result_criteria}
    ####################################################################################
    # TODO: do any other conversion needed
    return results_for_excel_export
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
    return patient_details
  end

  def get_population_details_from_measure(measure, results)
    population_details = {}
    ####################################################################################
    # These are snippets from the existing conversion in measure_view.js.coffee
    ####################################################################################
    # for pop in @model.get('populations').models
    #   for patient in @model.get('patients').models
    #   # Populates the population details
    #     if (population_details[pop.cid] == undefined)
    #       population_details[pop.cid] = {title: pop.get("title"), statement_relevance: result.get("statement_relevance")}
    #       criteria = []
    #       for popAttrs of pop.attributes
    #         if (popAttrs != "title" && popAttrs != "sub_id" && popAttrs != "title")
    #           criteria.push(popAttrs)
    #       population_details[pop.cid]["criteria"] = criteria
    ####################################################################################

    population_details = {}

    measure.populations.each do |population|
      # Populates the population details

      # ignores a population if its details have already been populated
      # TODO: LDY note - can't use cid here. using 'id'. however, this is a string. it *should* be unique but isn't guaranteed.
      # other option is an index...
      next if population_details[population[:id]]

      # TODO: LDY note - may need to change "result" -> don't yet know what this looks like
      population_details[population[:id]] = {title: population[:title], statement_relevance: results[:statement_relevance]}
      criteria = []
      # TODO: LDY note - comes back with "stratification_index" and "population_index", which I don't believe is intended.
      population.each_key do |key|
        criteria << key if key != "title" && key != "sub_id" && key != "id"
      end
      population_details[population[:id]][:criteria] = criteria
    end

    population_details
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

    return statement_details
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
