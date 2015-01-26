# FIXME: naming is confusing (dashboard is overloaded)
class Thorax.Views.Dashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/setup']
  className: "dashboard"

  events:
    rendered: -> @$('.instruction').addClass('hidden') if @vizView

  initialize: (@measureSet1, @measureSet2) ->

    # FIXME: We can add some caching; probably best at the collection level

    # Always display the measure sets selector
    @collection = new Thorax.Collections.MeasureSets
    @collection.fetch()

    # If measure sets have been selected, we display the visualization
    if measureSet1? && measureSet2?
      pairs = new Thorax.Collections.MeasurePairs([], measureSet1: measureSet1, measureSet2: measureSet2)
      pairs.fetch()
      @vizView = new Thorax.Views.ComplexityViz(collection: pairs)

  context: ->
    _(super()).extend(measureSet1: @measureSet1, measureSet2: @measureSet2)

  compare: ->
    measureSet1 = @$('#measureSet1').val()
    measureSet2 = @$('#measureSet2').val()
    bonnie.navigate "complexity/#{measureSet1}/#{measureSet2}", trigger: true


class Thorax.Views.ComplexityViz extends Thorax.Views.BonnieView
  template: JST['dashboard/viz']
  className: "dashboard"

  events:
    'mouseover .added-box': 'showAddedLines'
    'mouseout .added-box': 'hideAddedLines'
    'mouseover .deleted-box': 'showDeletedLines'
    'mouseout .deleted-box': 'hideDeletedLines'
    rendered: ->
      if @vizData.length > 0
        @$('#dashboard-viz').empty()
        d3.select('#dashboard-viz').datum(@vizData).call(@viz)
        @$('button[disabled=true]').attr('disabled', false)
    collection:
      sync: ->
        # sync should only ever happen once, so we can just default to the complexity visualization
        @vizData = @collection.complexityVizData()
        @render()

  initialize: ->
    @viz = bonnie.viz.MeasureComplexity()
    @vizData = @collection.complexityVizData()
    @state = viz: 'complexity', mode: 'graph'

  complexityGraph: ->
    if @state.viz == 'complexity'
      @viz.switchGraph() unless @state.mode == 'graph'
    else
      @viz = bonnie.viz.MeasureComplexity()
      @vizData = @collection.complexityVizData()
      @render()
    @state = viz: 'complexity', mode: 'graph'
    @updateButtonsAndLegend()

  complexityGrid: ->
    if @state.viz == 'complexity'
      @viz.switchGrid() unless @state.mode == 'grid'
    else
      @viz = bonnie.viz.MeasureComplexity()
      @vizData = @collection.complexityVizData()
      @render()
      @viz.switchGrid()
    @state = viz: 'complexity', mode: 'grid'
    @updateButtonsAndLegend()

  sizeByLargest: ->
    return if @state.viz == 'size' && @state.mode == 'largest'
    @viz = bonnie.viz.MeasureSize() if @state.viz != 'size'
    @vizData = @collection.sizeVizData('size')
    @render()
    @state = viz: 'size', mode: 'largest'
    @updateButtonsAndLegend()

  sizeByChange: ->
    return if @state.viz == 'size' && @state.mode == 'change'
    @viz = bonnie.viz.MeasureSize() if @state.viz != 'size'
    @vizData = @collection.sizeVizData('change')
    @render()
    @state = viz: 'size', mode: 'change'
    @updateButtonsAndLegend()

  updateButtonsAndLegend: ->
    @$('button').removeClass('btn-primary').addClass('btn-default').filter(".#{@state.viz}-#{@state.mode}").addClass('btn-primary')
    @$('.size-legend').removeClass('hidden') if @state.viz == 'size'

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
