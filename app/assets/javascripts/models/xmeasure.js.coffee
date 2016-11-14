###*
# Model representing an archived measure. This is a previously upload version of a measure.
###
class Thorax.Models.ArchivedMeasure extends Thorax.Models.Measure
  idAttribute: '_id'
  
  ###*
  # Initializes a lazy loaded archived measure.
  ###
  initialize: ->
    # Becasue we bootstrap patients we mark them as _fetched, so isEmpty() will be sensible.
    @set 'patients', new Thorax.Collections.Patients [], _fetched: true
  
  ###*
  # Deferred return version of the Backbone fetch function.
  # @return {deferred} Deferred object that resolves when the model fetch is completed. Rejects on fail.
  ###
  fetchDeferred: ->
    fetchDeferred = $.Deferred()
    if !@_fetched
      @fetch(
        success: (model) ->
          model._fetched = true
          fetchDeferred.resolve(model)
        error: (model) -> fetchDeferred.reject(model)
      )
    else
      fetchDeferred.resolve(@)
    return fetchDeferred


###*
# Lazy loaded collection of ArchivedMeasures for a particular measure. This is used in the measure upload history
# page when comparing how a patient evaluated.
###
class Thorax.Collections.ArchivedMeasures extends Thorax.Collections.DeferredCollection
  
  ###*
  # Initializes an ArchivedMeasures collection.
  # @param {Thorax.Models.ArchivedMeasures[]} models - Initial set of models in the collection. Rarely used.
  # @param {object} options - The options for this collection.
  # @param {string} options.measure_id - The id of the measure this collection is for.
  ###
  initialize: (models, options) ->
    @measure_id = options.measure_id
  
  # Defines the URL for the collection. Backbone uses this when fetching.
  url: -> "/measures/#{@measure_id}/archived_measures"
    
  model: Thorax.Models.ArchivedMeasure
  
  ###*
  # Custom parse method, overrides Backbone parse. This simply creates all the lazy loaded archived measures.
  # @param {object[]} response - Parsed response from the ajax call or initialization.
  # @param {object} options - Options. Unused, following Backbone structure.
  # @return {Thorax.Models.ArchivedMeasure[]} Array of lazy loaded archived measures.
  ###
  parse: (response, options) ->
    return _(response).map (arch_measure) ->
       new Thorax.Models.ArchivedMeasure {_id: arch_measure.measure_db_id}, _fetched: false
