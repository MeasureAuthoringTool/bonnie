describe 'ComplexityDashboardView', ->

  beforeEach ->
    @collection = new Thorax.Collection getJSONFixture('measure_sets.json'), parse: true
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
    measureSet1 = "54cad5fc69702d74b4000000"
    measureSet2 = "54cad74a69702d755a000000"
    @complexityView = new Thorax.Views.Dashboard(measureSet1, measureSet2)
    @complexityView.render()
    @complexityView.appendTo 'body'
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
    # vizView doesn't called render() here, so enable buttons manually
    @complexityView.vizView.$('button[disabled=true]').prop('disabled',false)

    @complexityView.vizView.$('button.complexity-graph').click()
    expect(@complexityView.vizView.complexityGraph).toHaveBeenCalled()
    @complexityView.vizView.$('button.complexity-grid').click()
    expect(@complexityView.vizView.complexityGrid).toHaveBeenCalled()
    @complexityView.vizView.$('button.size-largest').click()
    expect(@complexityView.vizView.sizeByLargest).toHaveBeenCalled()
    @complexityView.vizView.$('button.size-change').click()
    expect(@complexityView.vizView.sizeByChange).toHaveBeenCalled()
