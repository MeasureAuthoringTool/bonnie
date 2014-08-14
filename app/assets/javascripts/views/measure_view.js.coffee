class Thorax.Views.Measure extends Thorax.Views.BonnieView
  template: JST['measure']

  events:
    rendered: ->
      @exportPatientsView = new Thorax.Views.ExportPatientsView() # Modal dialogs for exporting
      @exportPatientsView.appendTo(@$el)
      $('.indicator-circle, .navbar-nav > li').removeClass('active')
      $('.indicator-results').addClass('active')
    'click .measure-listing': 'selectMeasureListing'

  initialize: ->
    populations = @model.get 'populations'
    population = populations.first()
    populationLogicView = new Thorax.Views.PopulationLogic(model: population)

    # display layout view when there are multiple populations; otherwise, just show logic view
    if populations.length > 1
      @logicView = new Thorax.Views.PopulationsLogic collection: populations
      @logicView.setView populationLogicView
    else
      @logicView = populationLogicView

    @populationCalculation = new Thorax.Views.PopulationCalculation(model: population)
    @logicView.listenTo @populationCalculation, 'logicView:showCoverage', -> @showCoverage()
    @logicView.listenTo @populationCalculation, 'logicView:clearCoverage', -> @clearCoverage()

    @populationCalculation.listenTo @logicView, 'population:update', (population) -> @updatePopulation(population)
    @populationCalculation.listenTo @, 'patients:toggleListing', -> @togglePatientsListing()
    @listenTo @logicView, 'population:update', (population) =>
      @$('.panel, .right-sidebar').animate(backgroundColor: '#fcf8e3').animate(backgroundColor: 'inherit')
    @listenTo @populationCalculation, 'select-patients:change', ->
      if @$('.select-patient:checked').size()
        @$('.measure-listing').removeClass('disabled')
      else
        @clearMeasureListings()
        @$('.measure-listing').addClass('disabled')
    # FIXME: change the name of these events to reflect what the measure calculation view is actually saying
    @logicView.listenTo @populationCalculation, 'rationale:clear', -> @clearRationale()
    @logicView.listenTo @populationCalculation, 'rationale:show', (result) -> @showRationale(result)
    @measures = @model.collection

  episodesOfCare: ->
    @model.get('source_data_criteria').filter((sdc) => sdc.get('source_data_criteria') in @model.get('episode_ids'))

  updateMeasure: (e) ->
    importMeasureView = new Thorax.Views.ImportMeasure(model: @model)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  exportPatients: (e) ->
    @exportPatientsView.exporting()

    @model.get('populations').whenDifferencesComputed =>
      differences = []
      @model.get('populations').each (population) ->
        differences.push(_(population.differencesFromExpected().toJSON()).extend(population.coverage().toJSON()))

      $.fileDownload "patients/export?hqmf_set_id=#{@model.get('hqmf_set_id')}", 
        successCallback: => @exportPatientsView.success()
        failCallback: => @exportPatientsView.fail()
        httpMethod: "POST"
        data: {authenticity_token: $("meta[name='csrf-token']").attr('content'), results: differences }

  toggleMeasureListing: (e) ->
    @$('.main').toggleClass('col-sm-8 col-sm-6')
    @$('.toggle-measure-listing').toggleClass('btn-default btn-measure-listing btn-primary btn-measure-listing-toggled')
    @$('.patients-listing-header').toggle()
    @clearMeasureListings()
    @trigger 'patients:toggleListing'
    @$('.measure-listing-sidebar').toggle()

  selectMeasureListing: (e) ->
    @clearMeasureListings()
    m = @$(e.target).model()
    if @$('.select-patient:checked').size()
      @$(".measure-#{m.get('hqmf_set_id')}").addClass('active')
      @$(".btn-clone-#{m.get('hqmf_set_id')}").show()

  clearMeasureListings: ->
    @$('.measure-listing').removeClass('active')
    @$('.btn-clone-patients').hide()

  cloneIntoMeasure: (e) ->
    $d = @$('.select-patient:checked')
    measure = @measures.findWhere({hqmf_set_id: @$(e.target).model().get('hqmf_set_id')})
    count = 0
    @$("#clonePatientsDialog").modal backdrop: 'static'
    @$(".rebuild-patients-progress-bar").css('width', '0%')
    @$("#clonePatientsDialog").on('hidden.bs.modal', -> bonnie.navigate "measures/#{measure.get('hqmf_set_id')}", trigger: true)
    for diff in $d
      difference = @$(diff).model()
      patient = @patients.findWhere({medical_record_number: difference.result.get('medical_record_id')})
      clonedPatient = patient.deepClone(omit_id: true)
      clonedPatient.set('measure_ids', [measure.get('hqmf_set_id')])
      clonedPatient.save clonedPatient.toJSON(),
        success: (model) =>
          @patients.add model # make sure that the patient exist in the global patient collection
          measure.get('patients').add model # and the measure's patient collection
          if bonnie.isPortfolio then @measures.each (m) -> m.get('patients').add model
          count++
          perc = (count / $d.size()) * 100
          @$(".clone-patients-progress-bar").css('width', perc.toFixed() + '%')
          if count == $d.size()
            @$("#clonePatientsDialog").modal 'hide'

  deleteMeasure: (e) ->
    @model = $(e.target).model()
    @model.destroy()
    bonnie.navigate '', trigger: true

  measureSettings: (e) ->
    e.preventDefault()
    @$('.delete-icon').click() if @$('.delete-measure').is(':visible')
    @$('.measure-settings').toggleClass('measure-settings-expanded')

  patientsSettings: (e) ->
    e.preventDefault()
    @$('.patients-settings').toggleClass('patients-settings-expanded')
    if @$('.measure-listing-sidebar').is(':visible') then @toggleMeasureListing(e)

  showDelete: (e) ->
    e.preventDefault()
    $btn = $(e.currentTarget)
    $btn.toggleClass('btn-danger btn-danger-inverse').prev().toggleClass('hide')
