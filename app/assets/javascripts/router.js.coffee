class BonnieRouter extends Backbone.Router

  initialize: ->
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collections.Measures()
    @patients = new Thorax.Collections.Patients()

  routes:
    '':                                         'renderMeasures'
    'measures':                                 'renderMeasures'
    'measures/matrix':                          'renderMatrix'
    'measures/:id':                             'renderMeasure'
    'patients':                                 'renderPatients'
    'patients/:id':                             'renderPatient'
    '(measures/:measure_id/)patients/:id/edit': 'renderPatientBuilder'
    '(measures/:measure_id/)patients/new':      'renderPatientBuilder'
    
  renderMeasures: ->
    measuresView = new Thorax.Views.Measures(measures: @measures)
    @mainView.setView(measuresView)

  renderMeasure: (id) ->
    measureView = new Thorax.Views.Measure(model: @measures.get(id), patients: @patients)
    @mainView.setView(measureView)

  renderPatients: ->
    patientsView = new Thorax.Views.Patients(patients: @patients)
    @mainView.setView patientsView

  renderPatient: (id) ->
    patientView = new Thorax.Views.Patient(measures: @measures, model: @patients.get(id))
    @mainView.setView patientView

  renderMatrix: ->
    matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @mainView.setView(matrixView)
    matrixView.calculateAsynchronously()

  renderPatientBuilder: (measureId, patientId) ->
    measure = @measures.get(measureId) if measureId
    patient = if patientId? then @patients.get(patientId) else new Thorax.Models.Patient {measure_id: measure?.id}, parse: true
    patientBuilderView = new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients)
    @mainView.setView patientBuilderView