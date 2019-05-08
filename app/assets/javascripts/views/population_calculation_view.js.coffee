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
      patient: difference.result.patient.toJSON()
      measure_id: @measure.get('cqmMeasure').hqmf_set_id
      episode_of_care: @measure.get('cqmMeasure').calculation_method == 'EPISODE_OF_CARE'

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
    deleteButton = @$(".delete-#{result.get('patient_id')}")
    deleteIcon = @$(e.currentTarget)
    # if we clicked on the icon, grab the icon button instead
    deleteIcon.toggleClass('btn-danger btn-danger-inverse')
    deleteButton.toggle()
    shareButton = @$(".share-#{result.get('patient_id')}")
    shareButton.toggle() # get share button out the way

  deletePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.get('patient_id')
    patient.destroy()
    result.destroy()
    @trigger 'rationale:clear'
    @coverageView.showCoverage()

  clonePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.get('patient_id')
    bonnie.navigateToPatientBuilder patient.deepClone(new_id: true, dedupName: true), @measure

  # The button to toggle a patient was disabled as part of BONNIE-1110.
  togglePatient: (e) ->
    $btn = $(e.currentTarget)

    result = $btn.model().result
    patient = @measure.get('patients').get result.get('patient_id')

    # toggle the patient's 'is_shared' attribute
    if patient.get('is_shared')
      patient.save({'is_shared': false}, silent: true)
      $btn.find('.btn-label').text 'Share'
    else
      patient.save({'is_shared': true}, silent: true)
      $btn.find('.btn-label').text 'Shared'

    # switch displayed button
    $btn.toggleClass 'btn-primary btn-primary-inverse'
    $btn.find('.share-icon').toggleClass 'fa-plus fa-minus'


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

  togglePatientsListing: ->
    @patientsListing = !@patientsListing
    @$('.coverage-summary').toggle()
    @render()
    if @patientsListing then @$('.summary').hide() else @$('.summary').show()
