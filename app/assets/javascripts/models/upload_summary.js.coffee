class Thorax.Models.UploadSummary extends Thorax.Model
  idAttribute: '_id'
  fetchDeferred: ->
    fetchDef = $.Deferred()
    @fetch(
      success: (model) -> fetchDef.resolve(model)
      error: (model) -> fetchDef.reject(model)
    )
    return fetchDef
    
class Thorax.Collections.UploadSummaries extends Thorax.Collection
  initialize: (models, options) ->
    @measure_id = options.measure_id
    
  url: -> "/measures/#{@measure_id}/upload_summaries"
    
  model: Thorax.Models.UploadSummary
  
  parse: (response, options) ->
    return _(response).map (upload_summary) -> 
      new Thorax.Models.UploadSummary upload_summary, _fetched: false
      
  fetchDeferred: ->
    fetchDef = $.Deferred()
    @fetch(
      success: (collection) -> fetchDef.resolve(collection)
      error: (collection) -> fetchDef.reject(collection)
    )
    return fetchDef
    
  fetchAll: ->
    fetchAllDef = $.Deferred()
    @fetchDeferred().then((collection) -> 
      $.when.apply(@, collection.map((model) -> model.fetchDeferred()))
        .done( ->
          fetchAllDef.resolve(collection))
        .fail( ->
          fetchAllDef.reject(collection))
      )
    return fetchAllDef
