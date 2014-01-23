class Thorax.Views.ValueSetsBuilder extends Thorax.View
  template: JST['value_sets_builder/value_sets_builder']

  initialize: ->
    # @defaultList = new Thorax.Collection()
    @whiteList = new Thorax.Collection()
    @blackList = new Thorax.Collection()
    @collection.each (vs) =>
      for concept in vs.get('concepts')
        if concept.black_list then @blackList.add vs
        else if concept.white_list then @whiteList.add vs
        # else @defaultList.add vs
    # @defaultListCollectionView = new Thorax.CollectionView
    #   collection: @defaultList
    #   itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: false, black: false)
    @whiteListCollectionView = new Thorax.CollectionView
      collection: @whiteList
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: true, black: false)
    @blackListCollectionView = new Thorax.CollectionView
      collection: @blackList
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: false, black: true)


class Thorax.Views.ValueSetView extends Thorax.View
  className: 'patient-criteria'

  template: JST['value_sets_builder/value_set']

  initialize: ->
    @codes = new Thorax.Collection()
    for concept in @model.get('concepts')
      if @white or @black
        if concept.white_list and @white then @codes.add concept
        if concept.black_list and @black then @codes.add concept
      else
        @codes.add concept

  toggleDetails: (e) ->
    e.preventDefault()
    @$('.criteria-details, form').toggleClass('hide')
    @$('.criteria-type-marker').toggleClass('open')