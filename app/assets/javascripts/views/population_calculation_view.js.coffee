class Thorax.Views.PopulationCalculation extends Thorax.View
  template: JST['population_calculation']

  initialize: ->
    @measure = @model.measure()
    @differences = @model.differencesFromExpected()
    # We want to display the results sorted by 1) failures first, then 2) last name, then 3) first name
    @differences.comparator = (d) -> [!d.get('done'), d.get('match'), d.result.patient.get('last'), d.result.patient.get('first')]
    @differences.sort()
    # Make sure the sort order updates as results come in
    @differences.on 'change', @differences.sort, @differences
    @totalCoverage = @model.coverage()

  context: ->
    _(super).extend measure_id: @measure.get('hqmf_set_id')

  differenceContext: (difference) ->
    _(difference.toJSON()).extend
      patient: difference.result.patient.toJSON()
      measure_id: @measure.get('hqmf_set_id')
      episode_of_care: @measure.get('episode_of_care')

  updatePopulation: (population) ->
    selectedResult = @$('.toggle-result').filter(':visible').model().result
    @setModel(population)
    @initialize()
    @render() # FIXME: we'd prefer not to explicitly render(), prefer to use a layout view or similar
    @trigger 'rationale:clear'
    if selectedResult?
      @$(".toggle-result-#{selectedResult.patient.id}").show()
      @trigger 'rationale:show', selectedResult

  showDelete: (e) ->
    result = @$(e.target).model().result
    deleteButton = @$(".delete-#{result.get('patient_id')}")
    deleteIcon = @$(e.currentTarget)
    # if we clicked on the icon, grab the icon button instead
    deleteIcon.toggleClass('btn-danger btn-danger-inverse')
    deleteButton.toggle()

  deletePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.get('patient_id')
    patient.destroy()
    result.destroy()

  clonePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.get('patient_id')
    bonnie.navigateToPatientBuilder patient.deepClone(omit_id: true, dedupName: true), @measure

  expandResult: (e) ->
    @trigger 'rationale:clear'
    result = $(e.target).model().result
    if @$(".toggle-result-#{result.patient.id}").is(":visible")
      @$(".toggle-result-#{result.patient.id}").hide()
      @trigger 'rationale:clear'
      @$(".expand-result-icon-#{result.patient.id}").removeClass('fa-angle-down').addClass('fa-angle-right')
    else
      @$('.toggle-result').hide()
      @$('.expand-result-icon').removeClass('fa-angle-down').addClass('fa-angle-right')
      @$(".toggle-result-#{result.patient.id}").show()
      @$(".expand-result-icon-#{result.patient.id}").removeClass('fa-angle-right').addClass('fa-angle-down')
      @trigger 'rationale:show', result

