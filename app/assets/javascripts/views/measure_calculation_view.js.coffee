class Thorax.Views.MeasureCalculation extends Thorax.View
  template: JST['measure_calculation']
  events:
    'click button.toggle-patient': 'patientClick'
    'click button.select-all':     'selectAll'
    'click button.select-none':    'selectNone'
  initialize: ->
    @results = new Thorax.Collection()
    # FIXME: It would be nice to have the counts update dynamically without re-rendering the whole table
    @results.on 'add remove', @render, this
    @population = @model.get('populations').at(@populationIndex)
    @logicView = new Thorax.Views.MeasureLogic(model: @model, population: @population)
    @resetComparisons()

  context: ->
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

  patientClick: (e) ->
    patient = $(e.target).model()
    if result = @results.findWhere(patient_id: patient.id)
      @updateComparisons(result, patient, e, false)
      @results.remove result
      @updateCell(result, patient, e, false)
      @logicView.clearRationale()
    else
      result = @population.calculate(patient)
      @updateComparisons(result, patient, e, true)
      @results.add result
      @updateCell(result, patient, e, true)
      @logicView.showRationale(@results.findWhere(patient_id: patient.id))

  selectAll: (e) ->
    # FIXME: This isn't cached in any way now (still reasonably fast!)
    @allPatients.each (p) =>
      result = @population.calculate(p)
      unless @results.findWhere(patient_id: p.id)?
        @updateComparisons(result, p, e, true)
        @results.add result
        @updateCell(result, p, e, true)
    @$('button.toggle-patient').addClass('active')

  selectNone: ->
    @resetComparisons()
    @results.set() # FIXME: Instead of reset() so we get individual adds and removes
    @$('button.toggle-patient').removeClass('active')

  updateCell: (result, patient, e, isInsert) ->
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
        if patient.get('expected_values')[@model.get('id')][@population.get('sub_id')][criteria] is result[criteria] 
          if isInsert
            @$(".#{populationClassMap[criteria]}-#{result.patient_id}").addClass("success")
          else
            @$(".#{populationClassMap[criteria]}-#{result.patient_id}").removeClass("success")
        else 
          if isInsert
            @$(".#{populationClassMap[criteria]}-#{result.patient_id}").addClass("danger")
          else 
            @$(".#{populationClassMap[criteria]}-#{result.patient_id}").removeClass("danger")
      else @$(".#{populationClassMap[criteria]}-#{result.patient_id}").addClass("warning")

  updateComparisons: (result, patient, e, isInsert) ->
    tablePopulations = ['IPP', 'DENOM', 'NUMER', 'DENEX', 'DENEXCEP']
    validPopulations = (criteria for criteria in tablePopulations when @population.get(criteria)?)
    for criteria in tablePopulations
      if criteria in validPopulations and patient.has('expected_values') and @model.get('id') in Object.keys(patient.get('expected_values'))
        found = result[criteria] ?= result.get(criteria)
        if patient.get('expected_values')[@model.get('id')][@population.get('sub_id')][criteria] is found
          if isInsert
            @comparisons.correct[criteria] += 1 
          else
            @comparisons.correct[criteria] -= 1
        else 
          if isInsert
            @comparisons.incorrect[criteria] += 1
          else 
            @comparisons.incorrect[criteria] -= 1
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
    