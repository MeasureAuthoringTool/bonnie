class Thorax.Views.Measures extends Thorax.Views.BonnieView

  template: JST['measures']

  initialize: ->
    toFinalize = @collection.select (m) -> m.get('needs_finalize')
    @finalizeMeasuresView = new Thorax.Views.FinalizeMeasures measures: new Thorax.Collections.Measures(toFinalize)

  importMeasure: (event) ->
    importMeasureView = new Thorax.Views.ImportMeasure(firstMeasure: (@collection.length == 0))
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  exportBundle: ->
    @exportBundleView.exporting()
    $.fileDownload "/users/bundle",
      successCallback: => @exportBundleView.success()
      failCallback: => @exportBundleView.fail()

  events:
    rendered: ->
      if @collection.isEmpty() then @importMeasure()
      else if @finalizeMeasuresView.measures.length
        @finalizeMeasuresView.appendTo(@$el)
        @finalizeMeasuresView.display()
      @exportBundleView = new Thorax.Views.ExportBundleView() # Modal dialogs for exporting
      @exportBundleView.appendTo(@$el)

class Thorax.Views.MeasureRowView extends Thorax.Views.BonnieView

  options:
    fetch: false

  initialize: ->
    # What we display changes for single vs multiple population measures
    @multiplePopulations = @model.get('populations').length > 1
    unless @multiplePopulations
      @differences = @model.get('populations').first().differencesFromExpected()

  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

class Thorax.Views.PopulationView extends Thorax.Views.BonnieView

  context: ->
    _(super).extend differences: @model.differencesFromExpected()

class Thorax.Views.PopulationTitle extends Thorax.Views.BonnieView
  template: JST['measure/population']
  editTemplate: JST['measure/population_edit']
  tagName: 'span'

  events:
    'keyup input': 'enterName'

  enterName: (e) ->
    if(e.keyCode is 13) then @save()

  edit: ->
    @$el.html(@renderTemplate(@editTemplate))
    @populate()

  save: ->
    @serialize()
    @model.save {}, type: 'PUT', success: => @$el.html(@renderTemplate(@template))

  cancel: -> @$el.html(@renderTemplate(@template))

class Thorax.Views.MeasurePercentageView extends Thorax.Views.BonnieView
  template: JST['measure/percentage']
  events:
    rendered: -> @$('.dial').knob()


class Thorax.Views.MeasureStatusView extends Thorax.Views.BonnieView
  template: JST['measure/status']


class Thorax.Views.MeasureFractionView extends Thorax.Views.BonnieView
  template: JST['measure/fraction']

class Thorax.Views.MeasureCoverageView extends Thorax.Views.BonnieView
  template: JST['measure/coverage']
  events:
    rendered: ->
      @$('.dial').knob()
      @showCoverage()

  showCoverage: ->
    @trigger 'logicView:showCoverage'
    @$('.btn-show-coverage').hide()

  hideCoverage: ->
    @trigger 'logicView:clearCoverage'
    @$('.btn-show-coverage').show()

  identifyCoverage: (e) ->
    $('.toggle-result').hide()
    @showCoverage()

