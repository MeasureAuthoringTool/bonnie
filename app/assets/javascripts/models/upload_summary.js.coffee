# This file needs the DeferredModel and DeferredCollection classes to be loaded first.
#= require ./deferred_model.js.coffee

###*
# Model representing an upload summary. This contains info about what changed during a measure upload. This is used in
# the post upload summary dialog and the measure upload history page.
###
class Thorax.Models.UploadSummary extends Thorax.Models.DeferredModel
  idAttribute: '_id'


###*
# Lazy loaded Collection for the UploadSummaries of a particular measure. This is used in the measure upload history 
# page. The Measure model has a property 'upload_summaries' to get this collection.
###
class Thorax.Collections.UploadSummaries extends Thorax.Collections.DeferredCollection
  
  ###*
  # Initializes a UploadSummaries collection.
  # @param {Thorax.Models.UploadSummary[]} models - Initial set of models in the collection. Rarely used.
  # @param {object} options - The options for this collection.
  # @param {string} options.measure_id - The id of the measure this collection is for.
  ###
  initialize: (models, options) ->
    @measure_id = options.measure_id
  
  # Defines the URL for the collection. Backbone uses this when fetching.
  url: -> "/measures/#{@measure_id}/upload_summaries"
    
  model: Thorax.Models.UploadSummary
  
  ###*
  # Custom parse method, overrides Backbone parse. This simply creates all the lazy loaded upload summaries.
  # @param {object[]} response - Parsed response from the ajax call or initialization.
  # @param {object} options - Options. Unused, following Backbone structure.
  # @return {Thorax.Models.UploadSummary[]} Array of lazy loaded upload summaries.
  ###
  parse: (response, options) ->
    return _(response).map (upload_summary) -> 
      new Thorax.Models.UploadSummary upload_summary, _fetched: false
