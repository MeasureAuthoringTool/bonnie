class Thorax.Models.UploadSummary extends Thorax.Model
  idAttribute: '_id'

class Thorax.Collections.UploadSummaries extends Thorax.Collection
  initialize: (models, options) ->
    @measure_id = options.measure_id
    
  url: -> "/measures/#{@measure_id}/upload_summaries"
    
  model: Thorax.Models.UploadSummary
  
  parse: (response, options) ->
    return _(response).map (upload_summary) -> 
      new Thorax.Models.UploadSummary upload_summary, _fetched: false
