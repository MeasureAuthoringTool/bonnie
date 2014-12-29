class Thorax.Views.PatientBankView extends Thorax.Views.BonnieView
  template: JST['patient_bank/patient_bank']
  events:
    'change input.select-patient':          'changeSelectedPatients'
    'click .clear-selected':                (e) -> @$('input.select-patient:checked').prop('checked',false).trigger("change")

    collection:
      sync: ->
        @model.get('populations').each (population) =>
          population_differences = @collection.map (patient) =>
            population.differenceFromExpected(patient)
          @allDifferences.add population_differences
        # set the differences to those calculated for the currently selected population
        @differences.reset @allDifferences.filter (d) => _(d.result.population).isEqual @currentPopulation

    rendered: ->
      @$('#sharedResults').on 'shown.bs.collapse hidden.bs.collapse', (e) =>
        @bankLogicView.clearRationale()
        if e.type is 'shown'
          @toggledPatient = $(e.target).model().result
          @bankLogicView.showRationale(@toggledPatient)
        else
          @toggledPatient = null
          @showSelectedPatients()

      @$('#sharedResults').on 'show.bs.collapse hidden.bs.collapse', (e) =>
        @$(e.target).prev('.panel-heading').toggleClass('opened-patient')
        @$(e.target).parent('.panel').find('.panel-chevron').toggleClass 'fa-angle-right fa-angle-down'

  initialize: ->
    @collection = new Thorax.Collections.Patients
    @differences = new Thorax.Collections.Differences
    @selectedPatients = new Thorax.Collection
    @listenTo @selectedPatients, 'add remove reset', _.bind(@showSelectedPatients, this)
    @selectedDifferences = new Thorax.Collection
    @allDifferences = new Thorax.Collection

    # wait so everything calculates
    @listenTo @differences, 'complete', ->
      @$('button[type=submit]').button('ready').removeAttr("disabled")
      @$('.patient-count').text "("+@$('.shared-patient:visible').length+")"  # show number of patients in bank
      @showSelectedPatients()

    populations = @model.get('populations')
    @currentPopulation = populations.first()
    populationLogicView = new Thorax.Views.PopulationLogic(model: @currentPopulation)
    if populations.length > 1
      @bankLogicView = new Thorax.Views.PopulationsLogic collection: populations
      @bankLogicView.setView populationLogicView
    else
      @bankLogicView = populationLogicView

    @listenTo @bankLogicView, 'population:update', (population) ->
      @currentPopulation = population # change to reflect the selection
      # keep track of patients who are currently toggled and/or selected
      toggledResult = @toggledPatient # {} one result model, also contains patient
      selectedPatients = @selectedPatients # a collection of patient models
      @differences.reset @allDifferences.filter (d) => _(d.result.population).isEqual @currentPopulation
      # make sure whatever patients are selected or toggled still hold
      if @toggledPatient
        associatedDifference = @differences.filter (d) => _(d.result.patient).isEqual @toggledPatient.patient
        @$('[data-model-cid="'+associatedDifference[0].cid+'"]').find("[data-toggle='collapse']").click()
      unless @selectedPatients.isEmpty()
        associatedDifferences = @differences.filter (d) => @selectedPatients.contains d.result.patient
        _(associatedDifferences).each (d) ->
          @$('[data-model-cid="'+d.cid+'"]').find('input.select-patient').prop('checked',true).trigger("change")

  differenceContext: (difference) ->
    _(difference.toJSON()).extend
      patient: difference.result.patient.toJSON()
      cms_id: @model.get('cms_id')

  changeSelectedPatients: (e) ->
    @$(e.target).closest('.panel-heading').toggleClass('selected-patient')
    patient = @$(e.target).model().result.patient # gets the patient model to add or remove
    if @$(e.target).is(':checked') then @selectedPatients.add patient else @selectedPatients.remove patient

  showSelectedPatients: ->
    #reflects the selected patient across the view
    if @selectedPatients.isEmpty()
      @selectedDifferences.reset @differences.models # show the coverage for everyone
    else
      # return the difference already calculated for this patient
      @selectedDifferences.reset @differences.filter (d) => @selectedPatients.contains d.result.patient
    @rationaleCriteria = []
    @selectedDifferences.each (difference) => if difference.get('done')
      result = difference.result
      rationale = result.get('rationale')
      @rationaleCriteria.push(criteria) for criteria, result of rationale when result
    @measureCriteria = @currentPopulation.dataCriteriaKeys()
    @rationaleCriteria = _(@rationaleCriteria).intersection(@measureCriteria)
    if not @toggledPatient then @bankLogicView.showSelectCoverage(@rationaleCriteria) # returns a custom coverage view
