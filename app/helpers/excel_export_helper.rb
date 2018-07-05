
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

  def get_patient_details_from_measure(measure)
    patient_details = {}
    ####################################################################################
    # These are snippets from the existing conversion in measure_view.js.coffee
    ####################################################################################
    # for pop in @model.get('populations').models
    #   for patient in @model.get('patients').models
    #     # Populates the patient details
    #     if !patient_details[patient.cid]
    #       patient_details[patient.cid] = {
    #         first: patient.get("first")
    #         last: patient.get("last")
    #         expected_values: patient.get("expected_values")
    #         birthdate: patient.get("birthdate")
    #         expired: patient.get("expired")
    #         deathdate: patient.get("deathdate")
    #         ethnicity: patient.get("ethnicity")
    #         race: patient.get("race")
    #         gender: patient.get("gender")
    #         notes: patient.get("notes")
    #       }
    ####################################################################################
    return patient_details
  end

  def get_population_details_from_measure(measure)
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
    return population_details
  end

  def get_statement_details_from_maesure(measure)
    statement_details = {}
    # CQLMeasureHelpers.buildDefineToFullStatement(@model) # TODO: port this coffeescript to ruby
    return statement_details
  end
end
