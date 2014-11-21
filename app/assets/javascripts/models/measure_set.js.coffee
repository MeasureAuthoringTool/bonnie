class Thorax.Models.MeasureSet extends Thorax.Model
  idAttribute: '_id'

class Thorax.Collections.MeasureSets extends Thorax.Collection
  url: 'complexity_dashboard/measure_sets'
  model: Thorax.Models.MeasureSet

class Thorax.Models.MeasurePair extends Thorax.Model

class Thorax.Collections.MeasurePairs extends Thorax.Collection
  url: -> "complexity_dashboard/measure_sets/#{@measureSet1},#{@measureSet2}"
  model: Thorax.Models.MeasurePair
  initialize: (_, options) ->
    @measureSet1 = options.measureSet1
    @measureSet2 = options.measureSet2
