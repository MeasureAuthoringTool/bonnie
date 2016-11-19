###*
# Base class for models that work in a deferred/lazy loaded manner. Provides fetching with returning a deferred.
###
class Thorax.Models.DeferredModel extends Thorax.Model
  
  ###*
  # Deferred return version of the Backbone fetch function. This fetches the entire model from the server.
  # @return {deferred} Deferred object that resolves when the model fetch is completed. Rejects on fail.
  ###
  loadModel: ->
    loadDeferred = $.Deferred()
    if !@_fetched
      @fetch(
        success: (model) ->
          model._fetched = true
          loadDeferred.resolve(model)
        error: (model) -> loadDeferred.reject(model)
      )
    else
      loadDeferred.resolve(@)
    return loadDeferred


###*
# Base class for collections that work in a deferred/lazy loaded manner. Provides fetching of just collection lising and
# fetching of all collection memebers with deferred returns.
###
class Thorax.Collections.DeferredCollection extends Thorax.Collection
  
  ###*
  # Load the collection from the server.
  # @param {boolean} isDeepLoad - Optional. If true then a deep load will occur and all models will be fully loaded.
  ###
  loadCollection: (isDeepLoad = false) ->
    loadDeferred = $.Deferred()
    
    # Fetch the collection listing from the server.
    @fetch(
      success: (collection) ->
        # if we are doing a deep load then load all the elements.
        if isDeepLoad
          $.when.apply(@, collection.map((model) -> model.loadModel()))
            .done( -> loadDeferred.resolve(collection) )
            .fail( -> loadDeferred.reject(collection) )
        # if we are not doing a deep load we can resolve the deferred.
        else
          loadDeferred.resolve(collection)
      error: (collection) -> loadDeferred.reject(collection)
    )
    return loadDeferred
