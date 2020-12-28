class Thorax.Views.PopulationCalculation extends Thorax.Views.BonnieView
  template: JST['population_calculation']

  initialize: ->
    @coverageView = new Thorax.Views.MeasureCoverageView(model: @model.coverage(), cql: @isCQL ? false)
    @listenTo @coverageView, 'logicView:showCoverage', ->
      @trigger 'logicView:showCoverage'
      @$('.expand-result-icon').removeClass('fa-angle-down').addClass('fa-angle-right')
    @listenTo @coverageView, 'logicView:clearCoverage', -> @trigger 'logicView:clearCoverage'
    @measure = @model.measure()
    @differences = @model.differencesFromExpected()
    # We want to display the results sorted by 1) failures first, then 2) last name, then 3) first name
    @differences.comparator = (d) -> [!d.get('done'), d.get('match'), d.result.patient.getLastName(), d.result.patient.getFirstName()]
    @differences.sort()
    # Make sure the sort order updates as results come in
    @differences.on 'change', @differences.sort, @differences
    @patientsListing = false
    @toggledPatient = null

  context: ->
    _(super).extend({measure_id: @measure.get('cqmMeasure').set_id})

  events:
    'click .select-patient': -> @trigger 'select-patients:change'

  differenceContext: (difference) ->
    _(difference.toJSON()).extend
      measure_id: @measure.get('cqmMeasure').set_id
      episode_of_care: @measure.get('cqmMeasure').calculation_method == 'EPISODE_OF_CARE'
      patientFirstName: difference.result.patient.getFirstName()
      patientLastName: difference.result.patient.getLastName()
      patientId: difference.result.patient.id


  updatePopulation: (population) ->
    selectedResult = @$('.toggle-result').filter(':visible').model().result
    @setModel(population)
    @initialize()
    @render() # FIXME: we'd prefer not to explicitly render(), prefer to use a layout view or similar
    @trigger 'rationale:clear'
    if selectedResult? && selectedResult.isPopulated()
      @$(".toggle-result-#{selectedResult.patient.id}").show()
      @trigger 'rationale:show', @$(".toggle-result-#{selectedResult.patient.id}").model().result
      @$(".expand-result-icon-#{selectedResult.patient.id}").removeClass('fa-angle-right').addClass('fa-angle-down')
      @coverageView.hideCoverage()
      @toggledPatient = @$(".toggle-result-#{selectedResult.patient.id}").model().result
    else @coverageView.showCoverage()

  showDelete: (e) ->
    result = @$(e.target).model().result
    deleteButton = @$(".delete-#{result.patient.id}")
    deleteIcon = @$(e.currentTarget)
    # if we clicked on the icon, grab the icon button instead
    deleteIcon.toggleClass('btn-danger btn-danger-inverse')
    deleteButton.toggle()
    shareButton = @$(".share-#{result.patient.id}")
    shareButton.toggle() # get share button out the way

  deletePatient: (e) ->
    difference = $(e.target).model()
    patient = @measure.get('patients').get difference.result.patient.id
    # If patient belongs to multiple measures, show dialog asking if we want to remove patient from specific measures else delete patient
    if (patient.get('cqmPatient').measure_ids.filter (id) -> id?).length > 1 && bonnie.isPortfolio
      patientsMeasures = @measure.collection.models.filter (measure) -> patient.get('cqmPatient').measure_ids.includes(measure.get('cqmMeasure').set_id)
      # Difference is needed by the patient dialog view if the user ultimately ends up removing patient from current measure
      deletePatientDialog = new Thorax.Views.DeletePatientDialog(model: patient, availableMeasures: patientsMeasures, submitCallback: @adjustMeasureIds, difference: difference)
      deletePatientDialog.appendTo(@$el)
      deletePatientDialog.display()
    else
      @patientDestroy(patient, difference.result)

  patientDestroy: (patient, result) ->
    patient.destroy()
    result.destroy()
    @trigger 'rationale:clear'
    @coverageView.showCoverage()

  copyPatient: (e) ->
    debugger
    result = $(e.target).model().result
    copyPatientView = new Thorax.Views.CopyPatientView(model: @measure, patientId: result.patient.id)
    copyPatientView.appendTo(@$el)
    copyPatientView.display()

  adjustMeasureIds: (patient, ids, difference) =>
    patient.attributes.cqmPatient.measure_ids = _.difference(patient.get('cqmPatient').measure_ids, ids);
    remaining = (patient.get('cqmPatient').measure_ids.filter (id) -> id != null ).length
    if remaining > 0
      # if we are removing selected patient from current measure remove from differences view
      if ids.includes(this.measure.attributes.cqmMeasure.set_id)
        @differences.remove(difference)
      # Remove patient from throrax collections so UI is up to date when user goes back to dashboard
      @measure.collection.models.forEach (mes) -> mes.attributes.patients.remove(patient) if ids.includes(mes.attributes.cqmMeasure.set_id)
      patient.save {cqmPatient: patient.get('cqmPatient')}, {silent: true}
    else
      @patientDestroy(patient, difference.result)

  clonePatient: (e) ->
    result = $(e.target).model().result
    patient = @measure.get('patients').get result.patient.id
    bonnie.navigateToPatientBuilder patient.deepClone(new_id: true, dedupName: true), @measure

  expandResult: (e) ->
    @trigger 'rationale:clear'
    result = $(e.target).model().result
    if @$(".toggle-result-#{result.patient.id}").is(":visible")
      @$(".toggle-result-#{result.patient.id}").hide()
      @$(".expand-result-icon-#{result.patient.id}").removeClass('fa-angle-down').addClass('fa-angle-right')
      @coverageView.showCoverage()
      @toggledPatient = null
    else
      @$('.toggle-result').hide()
      @$('.expand-result-icon').removeClass('fa-angle-down').addClass('fa-angle-right')
      @$(".toggle-result-#{result.patient.id}").show()
      @$(".expand-result-icon-#{result.patient.id}").removeClass('fa-angle-right').addClass('fa-angle-down')
      @trigger 'rationale:show', result
      @coverageView.hideCoverage()
      @toggledPatient = result

