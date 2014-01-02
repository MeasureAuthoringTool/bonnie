class BonnieRouter extends Backbone.Router

  initialize: ->
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collections.Measures()

    @calculator = new Calculator()

    # FIXME deprecated, use measure.get('patients') to get patients for individual measure
    @patients = new Thorax.Collections.Patients()

    @on 'route', -> window.scrollTo(0)


  routes:
    '':                                                'renderMeasures'
    'measures':                                        'renderMeasures'
    'measures/:hqmf_set_id':                           'renderMeasure'
    'patients':                                        'renderPatients'
    'patients/:id':                                    'renderPatient'
    'measures/:measure_hqmf_set_id/patients/:id/edit': 'renderPatientBuilder'
    'measures/:measure_hqmf_set_id/patients/new':      'renderPatientBuilder'
    'users':                                           'renderUsers'

  renderMeasures: ->
    # FIXME: We want the equivalent of a before filter; can probably override navigate w/super? @on route happens after, ok?
    @calculator.cancelCalculations()
    measuresView = new Thorax.Views.Measures(collection: @measures.sort())
    @mainView.setView(measuresView)

  renderMeasure: (hqmfSetId) ->
    @calculator.cancelCalculations()
    measureView = new Thorax.Views.Measure(model: @measures.findWhere({hqmf_set_id: hqmfSetId}), patients: @patients)
    @mainView.setView(measureView)

  renderUsers: ->
    @calculator.cancelCalculations()
    @users = new Thorax.Collections.Users()
    @users.fetch()
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

  renderPatientBuilder: (measureHqmfSetId, patientId) ->
    @calculator.cancelCalculations()
    measure = @measures.findWhere({hqmf_set_id: measureHqmfSetId}) if measureHqmfSetId
    patient = if patientId? then @patients.get(patientId) else new Thorax.Models.Patient {measure_id: measure?.get('hqmf_set_id')}, parse: true
    patientBuilderView = new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients)
    @mainView.setView patientBuilderView

  # This method is to be called directly, and not triggered via a
  # route; it allows the patient builder to be used in new patient
  # mode populated with data from an existing patient, ie a clone
  navigateToPatientBuilder: (patient, measure) ->
    measure ?= @measures.findWhere {hqmf_set_id: patient.get('measure_id')}
    @mainView.setView new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients)
    @navigate "measures/#{measure.get('hqmf_set_id')}/patients/new"
