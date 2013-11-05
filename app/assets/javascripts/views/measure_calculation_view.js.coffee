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
  context: ->
    _(super).extend
      IPPTotal: @results.where(IPP: 1).length
      DENOMTotal: @results.where(DENOM: 1).length
      NUMERTotal: @results.where(NUMER: 1).length
      DENEXTotal: @results.where(DENEX: 1).length
      DENEXCEPTotal: @results.where(DENEXCEP: 1).length
  patientClick: (e) ->
    patient = $(e.target).model()
    if result = @results.findWhere(patient_id: patient.id)
      @results.remove result
      @clearRationale()
    else
      @results.add @population.calculate(patient)
      @showRationale(@results.findWhere(patient_id: patient.id).get('rationale'))


  selectAll: ->
    # FIXME: This isn't cached in any way now (still reasonably fast!)
    @patients.each (p) => @results.add @population.calculate(p) unless @results.findWhere(patient_id: p.id)
    @$('button.toggle-patient').addClass('active')
  selectNone: ->
    @results.set() # FIXME: Instead of reset() so we get individual adds and removes
    @$('button.toggle-patient').removeClass('active')
  
  showRationale: (rationale) ->
    @clearRationale()
    for key, value of rationale
      target = $(".rationale .#{key}")
      if (target.length > 0)
        evalClass = if value then 'true_eval' else 'false_eval'
        target.addClass(evalClass)
      ""
  clearRationale: ->
    $('.rationale .rationale_target').removeClass('false_eval true_eval')


