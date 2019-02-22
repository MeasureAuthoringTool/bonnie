class Thorax.Views.CqlPatientBuilderLogic extends Thorax.Views.BonnieView

  template: JST['logic/cql_patient_builder_logic']

  initialize: ->
    @population_names = Object.keys(@model.get('populations_cql_map'))
    @results = {}
    for pop in @population_names
      @results[pop] = 0
    @cqlLogicView = new Thorax.Views.CqlPopulationLogic(model: @model, highlightPatientDataEnabled: true, population: @population)

  showRationale: (result) ->
    for pop in @population_names
      @results[pop] = result.get(pop)
    @cqlLogicView.showRationale result
    @render()

  runCqmExecution: ->
    patientID = @parent.parent.originalModel.id
    measureID = @parent.parent.measure.get('id')
    console.log('Converting and running with CQM')
    console.log(measureID: measureID, patientID: patientID)
    # cache for last cqm converted models
    @lastCQM = {}

    $.getJSON("/measures/#{measureID}/to_cqm")
      .done (measureVSJSON) =>
        @lastCQM.measure = new cqm.models.Measure(measureVSJSON.measure)
        @lastCQM.valueSets = measureVSJSON.value_sets
        console.log('Measure and value sets converted!')
        $.getJSON("/patients/#{patientID}/to_cqm")
          .done (patientJSON) =>
            @lastCQM.patient = new cqm.models.QDMPatient(patientJSON)
            console.log('Patient converted!')
            @_cqmExecute @lastCQM.measure, @lastCQM.patient, @lastCQM.valueSets

          .fail ->
            console.error('Failed to convert patient')
      .fail ->
        console.error('Failed to convert measure')
  
  _cqmExecute: (measure, patient, valueSets) ->
    console.log('executing with CQM-execution!')
    cqmResults = cqm.execution.Calculator.calculate(measure, [patient], valueSets, { doPretty: true, includeClauseResults: true })
    console.log cqmResults
