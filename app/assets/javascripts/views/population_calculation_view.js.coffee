class Thorax.Views.PopulationCalculation extends Thorax.Views.BonnieView
  template: JST['population_calculation']

  initialize: ->
    @coverageView = new Thorax.Views.MeasureCoverageView(model: @model.coverage(), cql: @isCQL ? false)
    @listenTo @coverageView, 'logicView:showCoverage', ->
      @trigger 'logicView:showCoverage'
      @$('.expand-result-icon').removeClass('fa-angle-down').addClass('fa-angle-right')
    @listenTo @coverageView, 'logicView:clearCoverage', -> @trigger 'logicView:clearCoverage'
    @measure = @model.measure()
    @differences = @model.differencesFromExpected()
    # We want to display the results sorted by 1) failures first, then 2) last name, then 3) first name
    @differences.comparator = (d) -> [!d.get('done'), d.get('match'), d.result.patient.getLastName(), d.result.patient.getFirstName()]
    @differences.sort()
    # Make sure the sort order updates as results come in
    @differences.on 'change', @differences.sort, @differences
    @patientsListing = false
    @toggledPatient = null

  context: ->
    _(super).extend({measure_id: @measure.get('cqmMeasure').hqmf_set_id, measure_is_composite: @measure.get('cqmMeasure').composite})

  events:
    'click .select-patient': -> @trigger 'select-patients:change'

  differenceContext: (difference) ->
    _(difference.toJSON()).extend
      measure_id: @measure.get('cqmMeasure').hqmf_set_id
      episode_of_care: @measure.get('cqmMeasure').calculation_method == 'EPISODE_OF_CARE'
      patientFirstName: difference.result.patient.getFirstName()
      patientLastName: difference.result.patient.getLastName()
      patientId: difference.result.patient.id


  updatePopulation: (population) ->
    selectedResult = @$('.toggle-result').filter(':visible').model().result
    @setModel(population)
    @initialize()
    @render() # FIXME: we'd prefer not to explicitly render(), prefer to use a layout view or similar
    @trigger 'rationale:clear'
    if selectedResult? && selectedResult.isPopulated()
      @$(".toggle-result-#{selectedResult.patient.id}").show()
      @trigger 'rationale:show', @$(".toggle-result-#{selectedResult.patient.id}").model().result
      @$(".expand-result-icon-#{selectedResult.patient.id}").removeClass('fa-angle-right').addClass('fa-angle-down')
      @coverageView.hideCoverage()
      @toggledPatient = @$(".toggle-result-#{selectedResult.patient.id}").model().result
    else @coverageView.showCoverage()

  showDelete: (e) ->
    result = @$(e.target).model().result
    deleteButton = @$(".delete-#{result.patient.id}")
    deleteIcon = @$(e.currentTarget)
    # if we clicked on the icon, grab the icon button instead
    deleteIcon.toggleClass('btn-danger btn-danger-inverse')
    deleteButton.toggle()
    shareButton = @$(".share-#{result.patient.id}")
    shareButton.toggle() # get share button out the way

  deletePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.patient.id
    # If patient belongs to multiple measures, show dialog asking if we want to remove patient from specific measures else delete patient
    if (patient.get('measure_ids').filter (id) -> id?).length > 1
      patientsMeasures = @measure.collection.models.filter (measure) -> patient.get('measure_ids').includes(measure.get('hqmf_set_id'))
      deletePatientDialog = new Thorax.Views.DeletePatientDialog(model: patient, availableMeasures: patientsMeasures, submitCallback: @adjustMeasureIds, result: result)
      deletePatientDialog.appendTo(@$el)
      deletePatientDialog.display()
    else
      @patientDestroy(patient,result)


  patientDestroy: (patient, result) ->
    patient.destroy()
    result.destroy()
    @trigger 'rationale:clear'
    @coverageView.showCoverage()

  adjustMeasureIds: (patient, ids, result) ->
    patient.attributes.measure_ids = _.difference(patient.attributes.measure_ids, ids)
    remaining = (patient.attributes.measure_ids.filter (id) -> id != null ).length
    if remaining > 0
      patient.save patient.toJSON()
    else
      @patientDestroy(patient,result)

  clonePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.patient.id
    bonnie.navigateToPatientBuilder patient.deepClone(new_id: true, dedupName: true), @measure

  expandResult: (e) ->
    @trigger 'rationale:clear'
    result = $(e.target).model().result
    if @$(".toggle-result-#{result.patient.id}").is(":visible")
      @$(".toggle-result-#{result.patient.id}").hide()
      @$(".expand-result-icon-#{result.patient.id}").removeClass('fa-angle-down').addClass('fa-angle-right')
      @coverageView.showCoverage()
      @toggledPatient = null
    else
      @$('.toggle-result').hide()
      @$('.expand-result-icon').removeClass('fa-angle-down').addClass('fa-angle-right')
      @$(".toggle-result-#{result.patient.id}").show()
      @$(".expand-result-icon-#{result.patient.id}").removeClass('fa-angle-right').addClass('fa-angle-down')
      @trigger 'rationale:show', result
      @coverageView.hideCoverage()
      @toggledPatient = result

