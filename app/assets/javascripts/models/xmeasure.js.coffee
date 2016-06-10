class Thorax.Models.ArchivedMeasure extends Thorax.Models.Measure
  idAttribute: '_id'
  initialize: ->
    # Becasue we bootstrap patients we mark them as _fetched, so isEmpty() will be sensible
    @set 'patients', new Thorax.Collections.Patients [], _fetched: true
  

class Thorax.Collections.ArchivedMeasures extends Thorax.Collection
  initialize: (models, options) ->
    @measure_id = options.measure_id
    
  url: -> "/measures/#{@measure_id}/archived_measures"
    
  model: Thorax.Models.ArchivedMeasure
  
  parse: (response, options) ->
    return _(response).map (arch_measure) ->
       new Thorax.Models.ArchivedMeasure {_id: arch_measure.measure_db_id}, _fetched: false
