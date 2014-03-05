class BonnieRouter extends Backbone.Router

  initialize: ->
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collections.Measures()

    @calculator = new Calculator()

    # FIXME deprecated, use measure.get('patients') to get patients for individual measure
    @patients = new Thorax.Collections.Patients()

    @on 'route', -> window.scrollTo(0, 0)

  routes:
    '':                                                'renderMeasures'
    'measures':                                        'renderMeasures'
    'measures/:hqmf_set_id':                           'renderMeasure'
    'measures/:measure_hqmf_set_id/patients/:id/edit': 'renderPatientBuilder'
    'measures/:measure_hqmf_set_id/patients/new':      'renderPatientBuilder'
    'admin/users':                                     'renderUsers'
    'value_sets/edit':                                 'renderValueSetsBuilder'
    'vt':                                              'testViz'

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

  renderPatientBuilder: (measureHqmfSetId, patientId) ->
    @calculator.cancelCalculations()
    measure = @measures.findWhere({hqmf_set_id: measureHqmfSetId}) if measureHqmfSetId
    patient = if patientId? then @patients.get(patientId) else new Thorax.Models.Patient {measure_ids: [measure?.get('hqmf_set_id')]}, parse: true
    patientBuilderView = new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients, measures: @measures)
    @mainView.setView patientBuilderView

  # This method is to be called directly, and not triggered via a
  # route; it allows the patient builder to be used in new patient
  # mode populated with data from an existing patient, ie a clone
  navigateToPatientBuilder: (patient, measure) ->
    # FIXME: Remove this when the Patients View is removed; select the first measure if a measure isn't passed in
    measure ?= @measures.findWhere {hqmf_set_id: patient.get('measure_ids')[0]}
    @mainView.setView new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: @patients, measures: @measures)
    @navigate "measures/#{measure.get('hqmf_set_id')}/patients/new"

  showError: (error)->
    errorDialogView = new Thorax.Views.ErrorDialog error: error
    errorDialogView.appendTo('#bonnie')
    errorDialogView.display();

  renderValueSetsBuilder: ->
    valueSets = new Thorax.Collections.ValueSetsCollection(_(bonnie.valueSetsByOid).values())
    valueSetsBuilderView = new Thorax.Views.ValueSetsBuilder(collection: valueSets, measures: @measures.sort(), patients: @patients)
    @mainView.setView(valueSetsBuilderView)

  testViz: ->
    measureVizTest = []
    @measures.each (m) =>
      measureView = new Thorax.Views.Measure(model: m, patients: @patients)
      console.log "Testing #{m.get('measure_id')}"
      @mainView.setView(measureView)
      if m.get('populations').length > 1
        tabs = $('a[data-toggle="tab"')
        for tab in tabs
          tab.click()
          measureView.$('.btn-measure-viz').click()
          if measureView.$('.d3-measure-viz > p').length == 1
            measureVizTest.push "#{m.get('measure_id')} [#{tab.text}]"
          else
            measureView.$('.btn-measure-viz').click()
    console.log measureVizTest
    console.log measureVizTest.length
