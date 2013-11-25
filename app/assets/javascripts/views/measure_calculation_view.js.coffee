class Thorax.Views.MeasureCalculation extends Thorax.View
  template: JST['measure_calculation']
  events:
    rendered: ->
      @$('.dial').knob()
    'click button.toggle-patient': 'patientClick'
    # 'click button.select-all':     'selectAll'
    # 'click button.select-none':    'selectNone'
  initialize: ->
    @results = new Thorax.Collections.Result
    # FIXME: It would be nice to have the counts update dynamically without re-rendering the whole table
    @results.on 'add remove', @render, this
    @population = @model.get('populations').at(@populationIndex)
    @resetComparisons()
    # only check against the first one since there is only one population
    @matching = @population.exactMatches()
    @percentage = 0
    unless @model.get('patients').isEmpty()
      @percentage = ((@matching / @model.get('patients').length) * 100).toFixed(0)
    @success = @matching is @model.get('patients').length

  context: ->
    s = @status()
    _(super).extend
      IPPTotal: @results.where(IPP: 1).length
      DENOMTotal: @results.where(DENOM: 1).length
      NUMERTotal: @results.where(NUMER: 1).length
      DENEXTotal: @results.where(DENEX: 1).length
      DENEXCEPTotal: @results.where(DENEXCEP: 1).length
      IPPPercent: ((@comparisons.correct.IPP / @totalComparisons) * 100).toFixed(2)
      DENOMPercent: ((@comparisons.correct.DENOM / @totalComparisons) * 100).toFixed(2)
      NUMERPercent: ((@comparisons.correct.NUMER / @totalComparisons) * 100).toFixed(2)
      DENEXPercent: ((@comparisons.correct.DENEX / @totalComparisons) * 100).toFixed(2)
      DENEXCEPPercent: ((@comparisons.correct.DENEXCEP / @totalComparisons) * 100).toFixed(2)
      status: s

  resultContext: (result) ->
    patient = @model.get('patients').get result.get('patient_id')
    _(result.toJSON()).extend
      measure_id: @model.id
      expectedValues: patient.get('expected_values')?[@model.id][@population.get('sub_id')]
      
  expectedPercentage: ->
    if @model.get('patients').isEmpty() then '-' else "#{@percentage}"
  matches: ->
      if @model.get('patients').isEmpty() then 0 else @matching
  status: -> 
    if @model.get('patients').isEmpty() then 'new' 
    else 
      if @success is true then 'success' else 'failed'

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

  selectAll: (e) ->
    # FIXME: This isn't cached in any way now (still reasonably fast!)
    @model.get('patients').each (p) =>
      result = @population.calculate(p)
      unless @results.findWhere(patient_id: p.id)?
        @updateComparisons(result, p, true)
        @results.add result
        @updateCell(result, p, true)
    @$('button.toggle-patient').addClass('active')

  selectNone: ->
    @resetComparisons()
    @results.set() # FIXME: Instead of reset() so we get individual adds and removes
    @$('button.toggle-patient').removeClass('active')

  updateCell: (result, patient, isInsert) ->
    # FIXME: Use all when measure calculation is updated for multiple populations
    tablePopulations = ['IPP', 'DENOM', 'NUMER', 'DENEX', 'DENEXCEP']
    populationClassMap =
      IPP: 'ipp'
      DENOM: 'denom'
      NUMER: 'numer'
      DENEX: 'denex'
      DENEXCEP: 'denexcep'
    validPopulations = (criteria for criteria in tablePopulations when @population.get(criteria)?)
    for criteria in tablePopulations
      if criteria in validPopulations and patient.has('expected_values') and @model.get('id') in _.keys(patient.get('expected_values'))
        if patient.get('expected_values')[@model.get('id')][@population.get('sub_id')][criteria] is result.get(criteria)
          if isInsert
            @$(".#{populationClassMap[criteria]}-#{result.get('patient_id')}").addClass("success")
          else
            @$(".#{populationClassMap[criteria]}-#{result.get('patient_id')}").removeClass("success")
        else
          if isInsert
            @$(".#{populationClassMap[criteria]}-#{result.get('patient_id')}").addClass("danger")
          else
            @$(".#{populationClassMap[criteria]}-#{result.get('patient_id')}").removeClass("danger")
      else @$(".#{populationClassMap[criteria]}-#{result.get('patient_id')}").addClass("warning")

  updateComparisons: (result, patient, isInsert) ->
    # FIXME: Use all when measure calculation is updated for multiple populations
    tablePopulations = ['IPP', 'DENOM', 'NUMER', 'DENEX', 'DENEXCEP']
    validPopulations = (criteria for criteria in tablePopulations when @population.get(criteria)?)
    for criteria in tablePopulations
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

  resetComparisons: ->
    @comparisons =
    correct:
      IPP: 0
      DENOM: 0
      NUMER: 0
      DENEX: 0
      DENEXCEP: 0
    incorrect:
      IPP: 0
      DENOM: 0
      NUMER: 0
      DENEX: 0
      DENEXCEP: 0
    # set the total to 1 to prevent NaN percentages
    @totalComparisons = 1

  updateTotalComparisons: ->
    sum = @comparisons.correct.IPP + @comparisons.incorrect.IPP
    if sum is 0 then @totalComparisons = 1 else @totalComparisons = sum

  showDelete: (e) ->
    result = @$(e.target).model()
    deleteButton = @$('.delete-' + result.get('patient_id'))
    deleteIcon = @$(e.target)
    # if we clicked on the icon, grab the icon button instead
    if deleteIcon[0].tagName is 'I' then deleteIcon = @$(deleteIcon[0].parentElement)
    if deleteIcon.hasClass('btn-default')
      deleteIcon.removeClass('btn-default')
      deleteIcon.addClass('btn-danger')
    else
      deleteIcon.removeClass('btn-danger')
      deleteIcon.addClass('btn-default')
    deleteButton.toggle()

  deletePatient: (e) ->
    result = $(e.target).model()
    patient = @model.get('patients').get result.get('patient_id')
    patient.destroy()
    result.destroy()

  clonePatient: (e) ->
    result = $(e.target).model()
    patient = @model.get('patients').get result.get('patient_id')
    bonnie.navigateToPatientBuilder patient.deepClone(), @model
