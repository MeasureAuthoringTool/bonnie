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
    
    if !@_fetched  # only fetch collection if it is not fetched
      # Fetch the collection listing from the server.
      @fetch(
        success: (collection) ->
          # if we are doing a deep load then load all the elements.
          if isDeepLoad
            collection._loadAllModels(loadDeferred)
          # if we are not doing a deep load we can resolve the deferred.
          else
            loadDeferred.resolve(collection)
        error: (collection) -> loadDeferred.reject(collection)
      )
      
    else if isDeepLoad  # if the collection is fetched and this is a deep load, we still may need to load models.
      @_loadAllModels(loadDeferred)
        
    else  # the collection is already fetched the returned deferred will be immediately resolved.
      loadDeferred.resolve(@)
      
    return loadDeferred
  
  ###*
  # Private method for loading all models in this collection and resolving a given deferred when completed.
  # @private
  # @param {deferred} deferredToResolve - The deferred object to resolve when complete or reject on failure.
  ###
  _loadAllModels: (deferredToResolve) ->
    collection = @  # hold on to 'this' since it will change when the deferred chain completes
    $.when.apply(@, collection.map((model) -> model.loadModel()))
      .done( -> deferredToResolve.resolve(collection) )
      .fail( -> deferredToResolve.reject(collection) )
