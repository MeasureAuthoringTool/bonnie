@BonnieRouter = class BonnieRouter extends Backbone.Router

  initialize: ->
    @maxErrorCount = 3
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collections.Measures()

    @calculator = new Calculator()

    # FIXME deprecated, use measure.get('patients') to get patients for individual measure
    @patients = new Thorax.Collections.Patients()

    @breadcrumb = new Thorax.Views.Breadcrumb()

    @on 'route', -> window.scrollTo(0, 0)

  routes:
    '':                                                 'renderMeasures'
    'measures':                                         'renderMeasures'
    'complexity':                                       'renderComplexity'
    'complexity/:set_1/:set_2':                         'renderComplexity'
    'measures/:hqmf_set_id':                            'renderMeasure'
    'measures/:hqmf_set_id/patient_dashboard':          'renderPatientDashboard'
    'measures/:hqmf_set_id/508_patient_dashboard':      'renderPatientDashboard'
    'measures/:measure_hqmf_set_id/patients/:id/edit':  'renderPatientBuilder'
    'measures/:measure_hqmf_set_id/patients/new':       'renderPatientBuilder'
    'measures/:measure_hqmf_set_id/patient_bank':       'renderPatientBank'
    'measures/:measure_hqmf_set_id/history':            'renderMeasureUploadHistory'
    'measures/:measure_hqmf_set_id/patients/:id/compare/at_upload/:upload_id':  'renderHistoricPatientCompare'
    'admin/users':                                      'renderUsers'
    'value_sets/edit':                                  'renderValueSetsBuilder'
    # This will catch any unmatched hashes and route them to showPageNotFound
    '*path':                                            'showPageNotFound'

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
    if measure?
      document.title += " - #{measure.get('cms_id')}" if measure?
      measureLayoutView = new Thorax.Views.MeasureLayout(measure: measure, patients: @patients)
      @mainView.setView(measureLayoutView)
      measureLayoutView.showDashboard !/508_patient_dashboard/.test(Backbone.history.getFragment()) # Checks to see if 508_patient_dashboard is not in the url
      @breadcrumb.addMeasure(measure)
    else
      @showPageNotFound()

  renderComplexity: (measureSet1, measureSet2) ->
    @navigationSetup "Complexity Dashboard", "complexity"
    @collection = new Thorax.Collections.MeasureSets
    @collection.fetch()
    complexityView = new Thorax.Views.Dashboard(measureSet1, measureSet2)
    complexityView.collection = @collection
    @mainView.setView(complexityView)

  renderMeasure: (hqmfSetId) ->
    measure = @measures.findWhere({hqmf_set_id: hqmfSetId})
    if measure?
      @navigationSetup "Measure View", "dashboard"
      document.title += " - #{measure.get('cms_id')}" if measure?
      measureLayoutView = new Thorax.Views.MeasureLayout(measure: measure, patients: @patients)
      @mainView.setView(measureLayoutView)
      measureLayoutView.showMeasure()
      @breadcrumb.addMeasure(measure)
    else
      @showPageNotFound()

  renderUsers: ->
    @navigationSetup "Admin", "admin"
    @users = new Thorax.Collections.Users()
    usersView = new Thorax.Views.Users(collection: @users)
    @mainView.setView(usersView)

  renderPatientBuilder: (measureHqmfSetId, patientId) ->
    measure = @measures.findWhere({hqmf_set_id: measureHqmfSetId}) if measureHqmfSetId
    patient = if patientId? then @patients.get(patientId) else new Thorax.Models.Patient {measure_ids: [measure?.get('hqmf_set_id')]}, parse: true
    if measure? and patient?
      @navigationSetup "Patient Builder", "patient-builder"
      document.title += " - #{measure.get('cms_id')}" if measure?
      patientBuilderView = new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients, measures: @measures, inPatientDashboard: false)
      @mainView.setView patientBuilderView
      @breadcrumb.addPatient(measure, patient)
    else
      @showPageNotFound()

  renderValueSetsBuilder: ->
    @navigationSetup "Value Sets Builder", "value-sets-builder"
    valueSets = new Thorax.Collections.ValueSetsCollection(_(bonnie.valueSetsByOid).values())
    valueSetsBuilderView = new Thorax.Views.ValueSetsBuilder(collection: valueSets, measures: @measures.sort(), patients: @patients)
    @mainView.setView(valueSetsBuilderView)

  renderPatientBank: (measureHqmfSetId) ->
    measure = @measures.findWhere(hqmf_set_id: measureHqmfSetId)
    if measure?
      @navigationSetup "Patient Bank - #{measure.get('cms_id')}", 'patient-bank'
      @collection = new Thorax.Collections.Patients
      @mainView.setView new Thorax.Views.PatientBankView model: measure, patients: @patients, collection: @collection
      @breadcrumb.addBank(measure)
    else
      @showPageNotFound()

  renderMeasureUploadHistory: (measureHqmfSetId) ->
    measure = @measures.findWhere(hqmf_set_id: measureHqmfSetId)
    if measure? 
      # show loading view because this data is loaded async. Show breadcrumb now so people know where they are heading.
      @mainView.setView new Thorax.Views.LoadingView
      @breadcrumb.viewMeasureHistory(measure)
      measure.get('upload_summaries').loadCollection(true)
      .done( (uploadSummaries) =>
        @navigationSetup "Measure Upload History - #{measure.get('cms_id')}", 'test-case-history'
        @mainView.setView new Thorax.Views.MeasureHistoryView model: measure, patients: measure.get('patients'), upload_summaries: uploadSummaries
        @breadcrumb.viewMeasureHistory(measure) )
      .fail( => @showError title: "Measure History Load Failed", summary: "Historic data failed to load due to a server error." )
    else
      @showPageNotFound()

  renderHistoricPatientCompare: (measureHqmfSetId, patientId, uploadId) ->
    @navigationSetup "Patient Builder", "patient-compare"
    measure = @measures.findWhere({hqmf_set_id: measureHqmfSetId}) if measureHqmfSetId
    patient = if patientId? then @patients.get(patientId) else new Thorax.Models.Patient {measure_ids: [measure?.get('hqmf_set_id')]}, parse: true
    if measure? and patient?
      document.title += " - #{measure.get('cms_id')}" if measure?
      # show loading view because this data is loaded async. Show breadcrumb now so people know where they are heading.
      @mainView.setView new Thorax.Views.LoadingView
      @breadcrumb.viewComparePatient(measure, patient) 
      
      # Deal with getting the archived measure and the calculation snapshot for the patient at measure upload
      measure.loadModelsForCompareAtUpload(uploadId)
        .done( (models) => 
          patientBuilderView = new Thorax.Views.PatientBuilderCompare(model: patient, measure: measure, patients: @patients, measures: @measures, preUploadMeasureVersion: models.beforeMeasure, uploadSummary: models.uploadSummary, postUploadMeasureVersion: models.afterMeasure)
          @mainView.setView patientBuilderView
          @breadcrumb.viewComparePatient(measure, patient) )
        .fail( => @showError title: "Historic Patient Compare Load Failed", summary: "Historic data failed to load due to a server error." )
    else
      @showPageNotFound()

  # Common setup method used by all routes
  navigationSetup: (title, selectedNav) ->
    @calculator.cancelCalculations()
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

  showMeasureUploadSummary: (uploadId, hqmfSetId) ->
    measure = @measures.findWhere(hqmf_set_id: hqmfSetId)
    
    # Shallow load the upload summaries and load the one we need to show.
    measure.get('upload_summaries').loadCollection()
      .then( (uploadSummaries) -> uploadSummaries.findWhere({_id: uploadId}).loadModel() )
      .done( (uploadSummary) ->
        measureUploadSummaryDialogView = new Thorax.Views.MeasureUploadSummaryDialog model: uploadSummary, measure: measure
        measureUploadSummaryDialogView.appendTo('#bonnie')
        measureUploadSummaryDialogView.display() )
        
  showPageNotFound: ->
    @mainView.setView new Thorax.Views.ErrorView
    @breadcrumb.clear()
