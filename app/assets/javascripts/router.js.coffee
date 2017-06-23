@BonnieRouter = class BonnieRouter extends Backbone.Router

  initialize: ->
    @maxErrorCount = 3
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collections.Measures()

    @calculator_selector = new CalculatorSelector()
    @cql_calculator = new CQLCalculator()
    @qdm_calculator = new QDMCalculator()

    # FIXME deprecated, use measure.get('patients') to get patients for individual measure
    @patients = new Thorax.Collections.Patients()

    @breadcrumb = new Thorax.Views.Breadcrumb()

    @on 'route', -> window.scrollTo(0, 0)

  routes:
    '':                                                'renderMeasures'
    'measures':                                        'renderMeasures'
    'complexity':                                      'renderComplexity'
    'complexity/:set_1/:set_2':                        'renderComplexity'
    'measures/:hqmf_set_id':                           'renderMeasure'
    'measures/:hqmf_set_id/patient_dashboard':         'renderPatientDashboard'
    'measures/:hqmf_set_id/508_patient_dashboard':     'renderPatientDashboard'
    'measures/:measure_hqmf_set_id/patients/:id/edit': 'renderPatientBuilder'
    'measures/:measure_hqmf_set_id/patients/new':      'renderPatientBuilder'
    'measures/:measure_hqmf_set_id/patient_bank':      'renderPatientBank'
    'admin/users':                                     'renderUsers'
    'value_sets/edit':                                 'renderValueSetsBuilder'

  renderMeasures: ->
    @measures.each (measure) -> measure.set('displayedPopulation', measure.get('populations').first())
    @navigationSetup "Dashboard", "dashboard"
    if @isPortfolio
      dashboardView = new Thorax.Views.Matrix(collection: @measures, patients: @patients)
    else
      dashboardView = new Thorax.Views.Measures(collection: @measures.sort(), patients: @patients)
    @mainView.setView(dashboardView)
    @breadcrumb.addMeasurePeriod()

  renderPatientDashboard: (hqmfSetId)->
    @navigationSetup "Patient Dashboard", "patient-dashboard"
    measure = @measures.findWhere({hqmf_set_id: hqmfSetId})
    document.title += " - #{measure.get('cms_id')}" if measure?
    measureLayoutView = new Thorax.Views.MeasureLayout(measure: measure, patients: @patients)
    @mainView.setView(measureLayoutView)
    measureLayoutView.showDashboard !/508_patient_dashboard/.test(Backbone.history.getFragment()) # Checks to see if 508_patient_dashboard is not in the url
    @breadcrumb.addMeasure(measure)

  renderComplexity: (measureSet1, measureSet2) ->
    @navigationSetup "Complexity Dashboard", "complexity"
    @collection = new Thorax.Collections.MeasureSets
    @collection.fetch()
    complexityView = new Thorax.Views.Dashboard(measureSet1, measureSet2)
    complexityView.collection = @collection
    @mainView.setView(complexityView)

  renderMeasure: (hqmfSetId) ->
    @navigationSetup "Measure View", "dashboard"
    measure = @measures.findWhere({hqmf_set_id: hqmfSetId})
    document.title += " - #{measure.get('cms_id')}" if measure?
    measureLayoutView = new Thorax.Views.MeasureLayout(measure: measure, patients: @patients)
    @mainView.setView(measureLayoutView)
    measureLayoutView.showMeasure()
    @breadcrumb.addMeasure(measure)

  renderUsers: ->
    @navigationSetup "Admin", "admin"
    @users = new Thorax.Collections.Users()
    usersView = new Thorax.Views.Users(collection: @users)
    @mainView.setView(usersView)

  renderPatientBuilder: (measureHqmfSetId, patientId) ->
    @navigationSetup "Patient Builder", "patient-builder"
    measure = @measures.findWhere({hqmf_set_id: measureHqmfSetId}) if measureHqmfSetId
    patient = if patientId? then @patients.get(patientId) else new Thorax.Models.Patient {measure_ids: [measure?.get('hqmf_set_id')]}, parse: true
    document.title += " - #{measure.get('cms_id')}" if measure?
    patientBuilderView = new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients, measures: @measures, inPatientDashboard: false)
    @mainView.setView patientBuilderView
    @breadcrumb.addPatient(measure, patient)

  renderValueSetsBuilder: ->
    @navigationSetup "Value Sets Builder", "value-sets-builder"
    valueSets = new Thorax.Collections.ValueSetsCollection(_(bonnie.valueSetsByOid).values())
    valueSetsBuilderView = new Thorax.Views.ValueSetsBuilder(collection: valueSets, measures: @measures.sort(), patients: @patients)
    @mainView.setView(valueSetsBuilderView)

  renderPatientBank: (measureHqmfSetId) ->
    measure = @measures.findWhere(hqmf_set_id: measureHqmfSetId)
    @navigationSetup "Patient Bank - #{measure.get('cms_id')}", 'patient-bank'
    @collection = new Thorax.Collections.Patients
    @mainView.setView new Thorax.Views.PatientBankView model: measure, patients: @patients, collection: @collection
    @breadcrumb.addBank(measure)

  # Common setup method used by all routes
  navigationSetup: (title, selectedNav) ->
    @calculator_selector.cancelCalculations()
    @breadcrumb.clear()
    document.title = "Bonnie v#{bonnie.applicationVersion}: #{title}"
    if selectedNav?
      $('ul.nav > li').removeClass('active').filter(".nav-#{selectedNav}").addClass('active')

  # This method is to be called directly, and not triggered via a
  # route; it allows the patient builder to be used in new patient
  # mode populated with data from an existing patient, ie a clone
  navigateToPatientBuilder: (patient, measure) ->
    # FIXME: Remove this when the Patients View is removed; select the first measure if a measure isn't passed in
    measure ?= @measures.findWhere {hqmf_set_id: patient.get('measure_ids')[0]}
    @mainView.setView new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients, measures: @measures, inPatientDashboard: false)
    @breadcrumb.addPatient(measure, patient)
    @navigate "measures/#{measure.get('hqmf_set_id')}/patients/new"

  showError: (error) ->
    return if $('.errorDialog').size() > @maxErrorCount
    if $('.errorDialog').size() == @maxErrorCount
      error.title = "Multiple Errors: #{error.title}"
      error.summary = "This page has generated multiple errors... additional errors will be suppressed. #{error.summary}"
    errorDialogView = new Thorax.Views.ErrorDialog error: error
    errorDialogView.appendTo('#bonnie')
    errorDialogView.display();
