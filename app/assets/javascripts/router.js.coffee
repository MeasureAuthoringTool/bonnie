class BonnieRouter extends Backbone.Router

  initialize: ->
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collection()
    @patients = new Thorax.Collections.Patients()

  routes:
    '':                'measures'
    'measures':        'measures'
    'measures/matrix': 'matrix'
    'measures/:id':    'measure'

  measures: ->
    measuresView = new Thorax.Views.Measures(measures: @measures)
    @mainView.setView(measuresView)

  measure: (id) ->
    measureView = new Thorax.Views.Measure(model: @measures.get(id))
    @mainView.setView(measureView)

  matrix: ->
    # FIXME: Since this can take a while implement a "loading" mechanism (using Thorax "loading" template helper?)
    # FIXME: Cache calculation so that it doesn't need to happen every time the matrix is displayed
    # FIXME: Can we cache the generation of these views?
    matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @mainView.setView(matrixView)
