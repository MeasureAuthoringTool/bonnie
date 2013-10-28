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
    else
      # FIXME: This isn't cached in any way now (still reasonably fast!)
      @results.add @model.calculate(patient)
  selectAll: ->
    # FIXME: This isn't cached in any way now (still reasonably fast!)
    @patients.each (p) => @results.add @model.calculate(p) unless @results.findWhere(patient_id: p.id)
    @$('button.toggle-patient').addClass('active')
  selectNone: ->
    @results.set() # FIXME: Instead of reset() so we get individual adds and removes
    @$('button.toggle-patient').removeClass('active')
