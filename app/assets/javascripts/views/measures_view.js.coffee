class Thorax.Views.Measures extends Thorax.View

  template: JST['measures']

  initialize: ->
    toFinalize = @collection.select (m) -> m.get('needs_finalize')
    @finalizeMeasuresView = new Thorax.Views.FinalizeMeasures measures: new Thorax.Collections.Measures(toFinalize)

  importMeasure: (event) ->
    importMeasureView = new Thorax.Views.ImportMeasure()
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  events:
    rendered: ->
      if @collection.isEmpty() then @importMeasure()


class Thorax.Views.MeasureRowView extends Thorax.View

  options:
    fetch: false

  initialize: ->
    # What we display changes for single vs multiple population measures
    @multiplePopulations = @model.get('populations').length > 1
    if @multiplePopulations
      # Create a collection of population titles and differences
      differencesCollection = @model.get('populations').map (p) -> _(p.pick('title')).extend(differences: p.differencesFromExpected())
      @differencesCollection = new Thorax.Collection differencesCollection
    else
      @differences = @model.get('populations').first().differencesFromExpected()

  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()


class Thorax.Views.MeasurePercentageView extends Thorax.View
  template: JST['measure/percentage']
  events:
    rendered: -> @$('.dial').knob()


class Thorax.Views.MeasureStatusView extends Thorax.View
  template: JST['measure/status']


class Thorax.Views.MeasureFractionView extends Thorax.View
  template: JST['measure/fraction']

class Thorax.Views.MeasureCoverageView extends Thorax.View
  template: JST['measure/coverage']

  # Uncommet below for debugging
  # identifyCoverage: (e) ->
  #   for criteria in @model.rationaleCriteria
  #     logicLine = $(".#{criteria}")
  #     if logicLine.hasClass('text-primary') then logicLine.removeClass('text-primary') else logicLine.addClass('text-primary')