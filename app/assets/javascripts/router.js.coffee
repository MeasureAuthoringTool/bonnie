class BonnieRouter extends Backbone.Router

  initialize: ->
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collections.Measures()
    @patients = new Thorax.Collections.Patients()

  routes:
    '':                                         'measures'
    'measures':                                 'measures'
    'measures/matrix':                          'matrix'
    'measures/:id':                             'measure'
    'patients':                                 'patients'
    'patients/:id':                             'patient'
    '(measures/:measure_id/)patients/:id/edit': 'patientBuilder'
    '(measures/:measure_id/)patients/new':      'patientBuilder'
    
  measures: ->
    # FIXME: Can we cache the generation of these views?
    measuresView = new Thorax.Views.Measures(measures: @measures)
    @mainView.setView(measuresView)

  measure: (id) ->
    measureView = new Thorax.Views.Measure(model: @measures.get(id), patients: @patients, allPopulationCodes: @all_population_codes)
    @mainView.setView(measureView)

  patients: ->
    patientsView = new Thorax.Views.Patients(patients: @patients)
    @mainView.setView patientsView

  patient: (id) ->
    patientView = new Thorax.Views.Patient(measures: @measures, model: @patients.get(id), sections: @sections, idMap: @template_id_map)
    @mainView.setView patientView

  matrix: ->
    matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @mainView.setView(matrixView)
    matrixView.calculateAsynchronously()

  patientBuilder: (measureId, patientId) ->
    measure = @measures.get(measureId) if measureId
    patient = if patientId? then @patients.get(patientId) else new Thorax.Models.Patient {measure_id: measure?.id}, parse: true
    patientBuilderView = new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients)
    @mainView.setView patientBuilderView