class Thorax.Views.Measures extends Thorax.Views.BonnieView

  template: JST['measures']

  initialize: ->
    toFinalize = @collection.select (m) -> m.get('needs_finalize')
    @finalizeMeasuresView = new Thorax.Views.FinalizeMeasures measures: new Thorax.Collections.Measures(toFinalize)

  importMeasure: (event) ->
    importMeasureView = new Thorax.Views.ImportMeasure(firstMeasure: (@collection.length == 0))
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  events:
    rendered: ->
      if @collection.isEmpty() then @importMeasure()
      else if @finalizeMeasuresView.measures.length
        @finalizeMeasuresView.appendTo(@$el)
        @finalizeMeasuresView.display()
      $('.indicator-circle, .navbar-nav > li').removeClass('active')
      $('.indicator-dashboard, .nav-dashboard').addClass('active')

class Thorax.Views.MeasureRowView extends Thorax.Views.BonnieView

  events:
    'click .edit-pop': 'editPopulationName'

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

  editPopulationName: (e) ->
    $(e.currentTarget).find('i').toggleClass 'fa-pencil fa-save'
    title = $(e.currentTarget).prev() 

    if title.is('span') 
      title.replaceWith -> return '<input id="population_edit" name="population_edit" type="text" value="'+$(@).html()+'">' #make it editable
    else 
      title.replaceWith -> 
        return '<span>'+this.value+'</span>' #make it uneditable

      pop =  $(e.currentTarget).closest('.row.population') #this population
      y = pop.siblings().addBack().index(pop) #tells us where this pop is in its group of pops

      @model.get('populations').at(y).set 'title', title.val()
      @model.save()

      console.log @model.get('populations').at(y).attributes.title

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

