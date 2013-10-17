class Thorax.Views.MeasureCalculation extends Thorax.View
  template: JST['measure_calculation']
  events:
    'click button': 'patientClick'
  initialize: ->
    @results = new Thorax.Collection()
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
