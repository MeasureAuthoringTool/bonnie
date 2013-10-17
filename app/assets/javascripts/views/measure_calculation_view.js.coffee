class Thorax.Views.MeasureCalculation extends Thorax.View
  template: JST['measureCalculation']
  initialize: ->
    # FIXME: This isn't cached in any way now (still reasonably fast!)
    @results = new Thorax.Collection(@patients.map (p) => @model.calculate(p))
