class Thorax.Views.Dashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/setup']
  className: "dashboard"

  initialize: ->
    @collection = new Thorax.Collections.MeasureSets
    @collection.fetch()

  compare: ->
    measureSet1 = @$('#measureSet1').val()
    measureSet2 = @$('#measureSet2').val()
    bonnie.navigate "dashboard/complexity/#{measureSet1}/#{measureSet2}", trigger: true

class Thorax.Views.SizeDashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/size']
  className: "dashboard"

  events:
    'mouseover .added-box': 'showAddedLines'
    'mouseout .added-box': 'hideAddedLines'
    'mouseover .deleted-box': 'showDeletedLines'
    'mouseout .deleted-box': 'hideDeletedLines'
    rendered: ->
      # FIXME: instead of these two lines, maybe just more buttons in the grid/graph area
      $('.indicator-circle, .navbar-nav > li').removeClass('active')
      $('.nav-dashboard-size').addClass('active')
      @viz = bonnie.viz.MeasureSize()
      d3.select(@$el.find('#size-grid').get(0)).datum(@collection.sizeVizData('change')).call(@viz)
    collection:
      sync: -> @render()

  showAddedLines: (e) ->
    @$('.added-box').addClass('darker')
    @viz.showAddedLines()

  hideAddedLines: (e) ->
    @$('.added-box').removeClass('darker')
    @viz.hideAddedLines()

  showDeletedLines: (e) ->
    @$('.deleted-box').addClass('darker')
    @viz.showDeletedLines()

  hideDeletedLines: (e) ->
    @$('.deleted-box').removeClass('darker')
    @viz.hideDeletedLines()

  sortByLargest: (e) ->
    d3.select(@$el.find('#size-grid').get(0)).datum(@collection.sizeVizData('size')).call(@viz)
    @$('.sort').toggleClass('btn-primary btn-default') unless @$('.sort-largest').hasClass('btn-primary')

  sortByMostChange: (e) ->
    d3.select(@$el.find('#size-grid').get(0)).datum(@collection.sizeVizData('change')).call(@viz)
    @$('.sort').toggleClass('btn-primary btn-default') unless @$('.sort-change').hasClass('btn-primary')

class Thorax.Views.ComplexityDashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/complexity']
  className: "dashboard"

  events:
    rendered: ->
      # FIXME: instead of these two lines, maybe just more buttons in the grid/graph area
      $('.indicator-circle, .navbar-nav > li').removeClass('active')
      $('.nav-dashboard').addClass('active')
      @viz = bonnie.viz.MeasureComplexity()
      d3.select(@$el.find('#chart').get(0)).datum(@collection.complexityVizData()).call(@viz)
    collection:
      sync: -> @render()

  switchGrid: (e) -> 
    @viz.switchGrid()
    @$('.switch').toggleClass('btn-primary btn-default') unless @$('.switch-grid').hasClass('btn-primary')

  switchGraph: (e) -> 
    @viz.switchGraph()
    @$('.switch').toggleClass('btn-primary btn-default') unless @$('.switch-graph').hasClass('btn-primary')
