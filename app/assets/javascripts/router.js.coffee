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
    'patients':        'patients'
    'patients/:id':    'patient'
    

  measures: ->
    # FIXME: Can we cache the generation of these views?
    measuresView = new Thorax.Views.Measures(measures: @measures)
    @mainView.setView(measuresView)

  measure: (id) ->
    if @measures.get(id) isnt undefined
      x = @measures.get(id)
    else
      x = @measures.findWhere({hqmf_id: id})
    measureView = new Thorax.Views.Measure(model: x)
    @mainView.setView(measureView)

  patients: ->
    patientsView = new Thorax.Views.Patients(patients: @patients)
    @mainView.setView(patientsView)

  patient: (id) ->
    patientView = new Thorax.Views.Patient(model: @patients.get(id))
    @mainView.setView(patientView)

  matrix: ->
    matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @mainView.setView(matrixView)
    matrixView.calculateAsynchronously()
