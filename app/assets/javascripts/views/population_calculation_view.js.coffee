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
    @totalCoverage = new Thorax.Model
    @listenTo @differences, 'differences:done', (differences) -> @computeTotalCoverage(differences.map (d) -> d.result)
    if @differences.summary.get('done') then @computeTotalCoverage(@differences.map (d) -> d.result)

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
    deleteButton = @$('.delete-' + result.get('patient_id'))
    deleteIcon = @$(e.target)
    # if we clicked on the icon, grab the icon button instead
    if deleteIcon[0].tagName is 'I' then deleteIcon = @$(deleteIcon[0].parentElement)
    if deleteIcon.hasClass('btn-danger-inverse')
      deleteIcon.removeClass('btn-danger-inverse')
      deleteIcon.addClass('btn-danger')
    else
      deleteIcon.removeClass('btn-danger')
      deleteIcon.addClass('btn-danger-inverse')
    deleteButton.toggle()

  deletePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.get('patient_id')
    patient.destroy()
    result.destroy()

  clonePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.get('patient_id')
    bonnie.navigateToPatientBuilder patient.deepClone(omit_id: true), @measure

  expandResult: (e) ->
    @trigger 'rationale:clear'
    result = $(e.target).model().result
    if @$(".toggle-result-#{result.patient.id}").is(":visible")
      @$(".toggle-result-#{result.patient.id}").hide()
      @trigger 'rationale:clear'
    else
      @$('.toggle-result').hide()
      @$(".toggle-result-#{result.patient.id}").show()
      @trigger 'rationale:show', result

  computeTotalCoverage: (results) ->
    dataCriteria = @measure.get 'data_criteria'
    rationaleCoverage = {}
    for result in results
      rationale = result.get 'rationale'
      for key, value of dataCriteria
        criteriaId = value['key']
        if !!rationale[criteriaId]
          rationaleCoverage[criteriaId] = true
        else
          unless !!rationaleCoverage[criteriaId]
            rationaleCoverage[criteriaId] = false

    matches = 0
    mismatches = 0
    for criteriaId, match of rationaleCoverage
      if match then matches++ else mismatches++
    unless matches == mismatches == 0
      @totalCoverage.set coverage: ( matches * 100 / ( matches + mismatches )).toFixed()
    else
      @totalCoverage.set coverage: 0
