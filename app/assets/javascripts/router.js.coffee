class BonnieRouter extends Backbone.Router

  initialize: ->
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collections.Measures()
    @users = new Thorax.Collections.Users()
    @users.fetch()
    # FIXME deprecated, use measure.get('patients') to get patients for individual measure
    @patients = new Thorax.Collections.Patients()


  routes:
    '':                                       'renderMeasures'
    'measures':                               'renderMeasures'
    'measures/matrix':                        'renderMatrix'
    'measures/:id':                           'renderMeasure'
    'patients':                               'renderPatients'
    'patients/:id':                           'renderPatient'
    'measures/:measure_id/patients/:id/edit': 'renderPatientBuilder'
    'measures/:measure_id/patients/new':      'renderPatientBuilder'
    'users':                                  'renderUsers'

  renderMeasures: ->
    $(".active").removeClass("active")
    $("#measures").addClass("active")

    measuresView = new Thorax.Views.Measures(collection: @measures.sort())
    @mainView.setView(measuresView)

  renderMeasure: (id) ->
    measureView = new Thorax.Views.Measure(model: @measures.get(id), patients: @patients)
    @mainView.setView(measureView)

  renderUsers: ->
    $(".active").removeClass("active")
    $("#users").addClass("active")
    usersView = new Thorax.Views.Users(collection: @users)
    @mainView.setView(usersView)

  # FIXME deprecated
  renderPatients: ->
    patientsView = new Thorax.Views.Patients(patients: @patients)
    @mainView.setView patientsView

  # FIXME deprecated
  renderPatient: (id) ->
    patientView = new Thorax.Views.Patient(measures: @measures, model: @patients.get(id))
    @mainView.setView patientView

  # FIXME deprecated
  renderMatrix: ->
    matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @mainView.setView(matrixView)
    matrixView.calculateAsynchronously()

  renderPatientBuilder: (measureId, patientId) ->
    measure = @measures.get(measureId) if measureId
    patient = if patientId? then @patients.get(patientId) else new Thorax.Models.Patient {measure_id: measure?.id}, parse: true
    patientBuilderView = new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients)
    @mainView.setView patientBuilderView

  # This method is to be called directly, and not triggered via a
  # route; it allows the patient builder to be used in new patient
  # mode populated with data from an existing patient, ie a clone
  navigateToPatientBuilder: (patient) ->
    measure = @measures.get patient.get('measure_id')
    @mainView.setView new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients)
    @navigate "measures/#{patient.get('measure_id')}/patients/new"
