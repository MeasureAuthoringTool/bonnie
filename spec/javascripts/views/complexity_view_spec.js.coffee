describe 'ComplexityDashboardView', ->

  beforeEach ->
    window.bonnieRouterCache.load('base_set')
    @collection = new Thorax.Collection getJSONFixture('measure_data/base_set/measure_sets.json'), parse: true
    @complexityView = new Thorax.Views.Dashboard collection: @collection
    @complexityView.render()
    @complexityView.appendTo 'body'
    spyOn(@complexityView, 'compare')

  afterEach ->
    @complexityView.remove()

  it 'shows dropdown menus', ->
    expect(@complexityView.$('#measureSet1')).toExist()
    expect(@complexityView.$('#measureSet2')).toExist()

  it 'submits selected measure sets to compare', ->
    # select 2012 and 2013 EH measures
    @complexityView.$('#measureSet1 option[value="54cad5fc69702d74b4000000"]').attr("selected","selected")
    @complexityView.$('#measureSet2 option[value="54cad74a69702d755a000000"]').attr("selected","selected")
    @complexityView.$('button[data-call-method="compare"]').click()
    expect(@complexityView.compare).toHaveBeenCalled()

describe 'ComplexityVizView', ->
  beforeEach ->
    window.bonnieRouterCache.load('empty_set')
    measureSet1 = "54cad5fc69702d74b4000000"
    measureSet2 = "54cad74a69702d755a000000"
    @complexityView = new Thorax.Views.Dashboard
    @measurePairs = new Thorax.Collections.MeasurePairs(getJSONFixture('measure_data/base_set/measure_diff.json'), measureSet1: measureSet1, measureSet2: measureSet2)
    @vizView = new Thorax.Views.ComplexityViz(collection: @measurePairs)
    @complexityView.vizView = @vizView
    @complexityView.appendTo 'body'
    @complexityView.render()
    @complexityView.vizView.render()
    spyOn(@complexityView.vizView, 'complexityGraph')
    spyOn(@complexityView.vizView, 'complexityGrid')
    spyOn(@complexityView.vizView, 'sizeByLargest')
    spyOn(@complexityView.vizView, 'sizeByChange')

  afterEach ->
    @complexityView.remove()

  it 'shows a viz', ->
    expect(@complexityView.vizView).toExist()

  it 'shows buttons to switch viz', ->
    expect(@complexityView.vizView.$('button.complexity-graph')).toExist()
    expect(@complexityView.vizView.$('button.complexity-grid')).toExist()
    expect(@complexityView.vizView.$('button.size-largest')).toExist()
    expect(@complexityView.vizView.$('button.size-change')).toExist()

  it 'uses buttons to call appropriate viz', ->
    @complexityView.vizView.$('button.complexity-graph').click()
    expect(@complexityView.vizView.complexityGraph).toHaveBeenCalled()
    @complexityView.vizView.$('button.complexity-grid').click()
    expect(@complexityView.vizView.complexityGrid).toHaveBeenCalled()
    @complexityView.vizView.$('button.size-largest').click()
    expect(@complexityView.vizView.sizeByLargest).toHaveBeenCalled()
    @complexityView.vizView.$('button.size-change').click()
    expect(@complexityView.vizView.sizeByChange).toHaveBeenCalled()

  it 'shows the complexity graph viz', ->
    expect(@complexityView.$("svg").length).toEqual 1
    expect(@complexityView.$("circle.dot").length).toEqual 29
    expect(@complexityView.$("text.cmsLabel").css('opacity')).toEqual '0'

  it 'shows the complexity size viz', ->
    @complexityView.vizView.viz = bonnie.viz.MeasureSize() if @complexityView.vizView.state.viz != 'size'
    @complexityView.vizView.vizData = @complexityView.vizView.collection.sizeVizData('size')
    @complexityView.vizView.render()
    expect(@complexityView.$("svg").length).toEqual 29
    expect(@complexityView.$("text#measure_title").length).toEqual 29
