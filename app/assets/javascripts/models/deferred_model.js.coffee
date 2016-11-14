###*
# Base class for models that work in a deferred/lazy loaded manner. Provides fetching with returning a deferred.
###
class Thorax.Models.DeferredModel extends Thorax.Model
  
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
# Base class for collections that work in a deferred/lazy loaded manner. Provides fetching of just collection lising and
# fetching of all collection memebers with deferred returns.
###
class Thorax.Collections.DeferredCollection extends Thorax.Collection
  
  ###*
  # Deferred return version of the Backbone fetch function. This does a shallow fetch. Collection members only have
  # basic info and need to be fetched.
  # @return {deferred} Deferred object that resolves when the collection fetch is completed. Rejects on fail.
  ###
  fetchDeferred: ->
    fetchDeferred = $.Deferred()
    if !@_fetched
      @fetch(
        success: (collection) -> fetchDeferred.resolve(collection)
        error: (collection) -> fetchDeferred.reject(collection)
      )
    else
      fetchDeferred.resolve(@)
    return fetchDeferred
  
  ###*
  # Deferred return 'deep' fetch. This does fetch of the collection then fetches all collection memebers. 
  # @return {deferred} Deferred object. Resolves when the collection and model fetches are completed. Rejects on fail.
  ###
  fetchAll: ->
    fetchAllDeferred = $.Deferred()
    @fetchDeferred().then((collection) ->
      $.when.apply(@, collection.map((model) -> model.fetchDeferred()))
        .done( ->
          fetchAllDeferred.resolve(collection))
        .fail( ->
          fetchAllDeferred.reject(collection))
      )
    return fetchAllDeferred
