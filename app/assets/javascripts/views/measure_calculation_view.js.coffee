class Thorax.Views.MeasureCalculation extends Thorax.View
  template: JST['measure_calculation']
  events:
    rendered: ->
      @$('.dial').knob()
    # 'click button.toggle-patient': 'patientClick'
  initialize: ->
    @results = new Thorax.Collections.Result
    # FIXME: It would be nice to have the counts update dynamically without re-rendering the whole table
    @results.on 'add remove', @render, this
    @population = @model.get('populations').at(@populationIndex)
    @updateResultsHeader()
    @buildResults()
    @sortResults()

  context: ->
    s = @status()
    _(super).extend
      # IPPTotal: @results.where(IPP: 1).length
      # DENOMTotal: @results.where(DENOM: 1).length
      # NUMERTotal: @results.where(NUMER: 1).length
      # DENEXTotal: @results.where(DENEX: 1).length
      # DENEXCEPTotal: @results.where(DENEXCEP: 1).length
      # IPPPercent: ((@comparisons.correct.IPP / @totalComparisons) * 100).toFixed(2)
      # DENOMPercent: ((@comparisons.correct.DENOM / @totalComparisons) * 100).toFixed(2)
      # NUMERPercent: ((@comparisons.correct.NUMER / @totalComparisons) * 100).toFixed(2)
      # DENEXPercent: ((@comparisons.correct.DENEX / @totalComparisons) * 100).toFixed(2)
      # DENEXCEPPercent: ((@comparisons.correct.DENEXCEP / @totalComparisons) * 100).toFixed(2)
      status: s

  resultContext: (result) ->
    patient = @model.get('patients').get result.get('patient_id')
    expectedValues = patient.get('expected_values')?[@model.get('hqmf_set_id')]?[@population.get('sub_id')]
    popTitle = @population.get('title')
    validPopulations = (criteria for criteria in Thorax.Models.Measure.allPopulationCodes when @population.has(criteria))
    combinedResults = {}
    patientStatus = @population.isExactlyMatching(patient)
    for p in validPopulations
      combinedResults[p] = { name: p, expected: expectedValues?[p], result: result.get(p) }
    console.log combinedResults
    _(result.toJSON()).extend
      measure_id: @model.get('hqmf_set_id')
      populationTitle: popTitle ?= @population.get('sub_id')
      resultRow: combinedResults
      patientStatusText: if patientStatus then 'pass' else 'fail'
      patientStatus: patientStatus
      
  expectedPercentage: ->
    if @model.get('patients').isEmpty() then '-' else "#{@percentage}"

  matches: ->
    if @model.get('patients').isEmpty() then 0 else @matching

  status: -> 
    if @model.get('patients').isEmpty() then 'new' 
    else 
      if @success is true then 'pass' else 'fail'

  updatePopulation: (population) ->
    selectedPatient = @$('.toggle-result').filter(':visible').attr('class')
    @populationIndex = _.indexOf(@model.get('populations'),population)
    @population = population
    @updateResultsHeader()
    @results.reset()
    @trigger 'rationale:clear'
    @buildResults()
    @sortResults()
    @render()
    resultClass = (selectedPatient?.split " ")?[2]
    resultId = (resultClass?.split "-")?[2]
    @$(".#{resultClass}").show()
    result = @results.findWhere(patient_id: resultId)
    if result? then @trigger 'rationale:show', result

  updateResultsHeader: ->
    @matching = @population.exactMatches()
    @percentage = 0
    unless @model.get('patients').isEmpty()
      @percentage = ((@matching / @model.get('patients').length) * 100).toFixed(0)
    @success = @matching is @model.get('patients').length

  buildResults: ->
    @model.get('patients').each (p) =>
      @results.add @population.calculate(p)

  sortResults: ->
    p = @population
    m = @model
    # First, group the patients by their pass/fail status
    sortedResults = _.groupBy(@results.pluck('patient_id'), (r) ->
      patient = m.get('patients').get r
      return p.isExactlyMatching(patient)
      )
    # Then, sort the respective lists by "last first"
    _.each sortedResults, (value, key, list) ->
      list[key] = _.sortBy(value, (r) ->
          patient = m.get('patients').get r
          return "#{patient.get('last')} #{patient.get('first')}"
        )
    resultsCopy = @results.clone()
    @results.reset()
    if 'false' in _.keys(sortedResults)
      for pid in sortedResults?.false
        @results.add resultsCopy.findWhere(patient_id: pid), {sort:false}
    if 'true' in _.keys(sortedResults)
      for pid in sortedResults?.true
        @results.add resultsCopy.findWhere(patient_id: pid), {sort:false}
    resultsCopy.reset()

  showDelete: (e) ->
    result = @$(e.target).model()
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
    result = $(e.target).model()
    patient = @model.get('patients').get result.get('patient_id')
    patient.destroy()
    result.destroy()

  clonePatient: (e) ->
    result = $(e.target).model()
    patient = @model.get('patients').get result.get('patient_id')
    bonnie.navigateToPatientBuilder patient.deepClone(omit_id: true), @model

  expandResult: (e) ->
    @trigger 'rationale:clear'
    result = $(e.target).model()
    if @$(".toggle-result-#{result.get('patient_id')}").is(":visible")
      @$(".toggle-result-#{result.get('patient_id')}").hide()
      @trigger 'rationale:clear'
    else
      @$('.toggle-result').hide()
      @$(".toggle-result-#{result.get('patient_id')}").show()
      @trigger 'rationale:show', result

  # DEPRECATED
  patientClick: (e) ->
    patient = $(e.target).model()
    # if result = @results.findWhere(patient_id: patient.id)
    #   @updateComparisons(result, patient, false)
    #   @results.remove result
    #   @updateCell(result, patient, false)
    @trigger 'rationale:clear'
    @selectNone()
    # else
    result = @population.calculate(patient)
    @updateComparisons(result, patient, true)
    @results.add result
    @updateCell(result, patient, true)
    @trigger 'rationale:show', result

  # DEPRECATED
  selectAll: (e) ->
    # FIXME: This isn't cached in any way now (still reasonably fast!)
    @model.get('patients').each (p) =>
      result = @population.calculate(p)
      unless @results.findWhere(patient_id: p.id)?
        @updateComparisons(result, p, true)
        @results.add result
        @updateCell(result, p, true)
    @$('button.toggle-patient').addClass('active')

  # DEPRECATED
  selectNone: ->
    @resetComparisons()
    @results.set() # FIXME: Instead of reset() so we get individual adds and removes
    @$('button.toggle-patient').removeClass('active')

  # DEPRECATED
  updateCell: (result, patient, isInsert) ->
    allPopulations = Thorax.Models.Measure.allPopulationCodes
    validPopulations = (criteria for criteria in allPopulations when @population.get(criteria)?)
    for criteria in allPopulations
      if criteria in validPopulations and patient.has('expected_values') and @model.get('id') in _.keys(patient.get('expected_values'))
        if patient.get('expected_values')[@model.get('id')][@population.get('sub_id')][criteria] is result.get(criteria)
          if isInsert
            @$(".#{criteria}-#{result.get('patient_id')}").addClass("success")
          else
            @$(".#{criteria}-#{result.get('patient_id')}").removeClass("success")
        else
          if isInsert
            @$(".#{criteria}-#{result.get('patient_id')}").addClass("danger")
          else
            @$(".#{criteria}-#{result.get('patient_id')}").removeClass("danger")
      else @$(".#{criteria}-#{result.get('patient_id')}").addClass("warning")

  # DEPRECATED
  updateComparisons: (result, patient, isInsert) ->
    # FIXME: Use all when measure calculation is updated for multiple populations
    allPopulations = Thorax.Models.Measure.allPopulationCodes
    validPopulations = (criteria for criteria in allPopulations when @population.get(criteria)?)
    for criteria in allPopulations
      if criteria in validPopulations and patient.has('expected_values') and @model.get('id') in Object.keys(patient.get('expected_values'))
        if patient.get('expected_values')[@model.id][@population.get('sub_id')][criteria] is result.get(criteria)
          if isInsert
            @comparisons.correct[criteria]++
          else
            @comparisons.correct[criteria]--
        else
          if isInsert
            @comparisons.incorrect[criteria]++
          else
            @comparisons.incorrect[criteria]--
    @updateTotalComparisons()

  # DEPRECATED
  resetComparisons: ->
    @comparisons = {}
    @comparisons['correct'] = {}
    @comparisons['incorrect'] = {}
    for criteria in Thorax.Models.Measure.allPopulationCodes
      @comparisons['correct'][criteria] = 0
      @comparisons['incorrect'][criteria] = 0
    # set the total to 1 to prevent NaN percentages
    @totalComparisons = 1

  # DEPRECATED
  updateTotalComparisons: ->
    sum = @comparisons.correct.IPP + @comparisons.incorrect.IPP
    if sum is 0 then @totalComparisons = 1 else @totalComparisons = sum
  