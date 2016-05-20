class Thorax.Views.ValueSetCodesPageableList extends Thorax.CollectionView
  # The collection here must be a Backbone.PageableCollection to work properly
  # See http://backbone-paginator.github.io/backbone.paginator/api/ for details
  # on the backbone plugin that makes paginated collections a thing
  template: JST['measure/value_sets/codes_list']
  events:
    rendered: ->
      # this takes the bootstrap pagination component and makes it more usable.
      # see http://esimakin.github.io/twbs-pagination/ for docs
      @$('.pagination').twbsPagination
        totalPages: @collection.state.totalPages
        visiblePages: 7
        startPage: @collection.state.currentPage
        initiateStartPageClick: false
        onPageClick: (event, page) => @collection.getPage(page)

  itemView: (item) => new Thorax.Views.ValueSetCodes(model: item.model)

  initialize: ->
    # when a new page is accessed the collection resets. when this happens,
    # we re-render the view so the display shows updated selected page etc.
    @listenTo @collection, 'reset', => @render()

class Thorax.Views.ValueSetCodes extends Thorax.Views.BonnieView
  template: JST['measure/value_sets/codes_items']
  tagName: 'tr'
  events:
    'click .expand': (event) ->
      @descriptionExpanded = !@descriptionExpanded
      @render()

  initialize: ->
    @descriptionExpanded = false
