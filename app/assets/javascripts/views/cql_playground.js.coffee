class PatientSource
  constructor: (@patients) -> @index = 0
  currentPatient: -> new CQL_QDM.CQLPatient(@patients.at(@index)) if @patients.at(@index)
  nextPatient: -> @index += 1

class Thorax.Views.CQLPlaygroundView extends Thorax.Views.BonnieView

  template: JST['cql/cql_playground']

  initialize: ->
    @collapsedId = null
    @resultCollection = new Thorax.Collection()
    @collection.each (patient) =>
      @resultCollection.add(new Thorax.Model(id: patient.id, first: patient.get('first'), last: patient.get('last'), results: {}))
    @resultsView = new Thorax.Views.CQLResultsView(collection: @resultCollection)

  events:
    "ready": ->
      @$('#cqlPlayground').modal(backdrop: 'static', show: true)
      @editor = ace.edit("editor")
      @editor.setTheme("ace/theme/chrome")
      @editor.session.setMode("ace/mode/cql")
      @editor.setShowPrintMargin(false)
      $("#cqlPlayground").on 'hide.bs.modal', ->
        $('#cqlPlayground').remove()

  evaluateCql: (sender) ->
    @startEvaluateSpinner()
    cql = @editor.getValue()
    post = $.post "measures/cql_to_elm", { cql: cql, authenticity_token: $("meta[name='csrf-token']").attr('content') }
    post.done (response) => @updateElm(response)
    post.fail (response) => @displayErrors(response)
    @editor.focus()

  updateElm: (elm) ->
    @stopEvaluateSpinner()
    @editor.getSession().clearAnnotations()
    patientSource = new PatientSource(@collection)
    results = executeSimpleELM(elm, patientSource, @valueSetsForCodeService())
    @resultCollection.each (patient) => patient.set(results: results.patientResults[patient.id])

  displayErrors: (response) ->
    @stopEvaluateSpinner()
    switch response.status
      when 500
        alert "CQL translation error: #{response.statusText}"
      when 400
        errors = []
        for annotation in response.responseJSON.library.annotation
          error =
            row: annotation.startLine-1
            column: 0
            text: annotation.message
            type: 'error'
          errors.push error
        @editor.getSession().setAnnotations(errors)

  valueSetsForCodeService: ->
    valueSetsForCodeService = {}
    for oid, vs of bonnie.valueSetsByOid
      continue unless vs.concepts
      valueSetsForCodeService[oid] ||= {}
      valueSetsForCodeService[oid][vs.version] ||= []
      for concept in vs.concepts
        valueSetsForCodeService[oid][vs.version].push code: concept.code, system: concept.code_system_name, version: vs.version
    valueSetsForCodeService

  startEvaluateSpinner: ->
    $('#evaluate').button('loading')

  stopEvaluateSpinner: ->
    setTimeout ( ->
      $('#evaluate').button('reset')
    ), 500

class Thorax.Views.CQLResultView extends Thorax.Views.BonnieView
  template: JST['cql/cql_result_view']

  events:
    rendered: ->
      # Add hover to all data criteria results
      for type in @types
        if type.value instanceof Array
          for dc in type.value
            popoverContent = @$('.cql-entry-details-' + dc.entry._id).html()
            @$('.cql-entry-' + dc.entry._id).popover trigger: 'hover', placement: 'left', container: 'body', title: "Details", html: true, content: popoverContent

  initialize: ->
    @icons =
      characteristic:            'fa-user'
      communications:            'fa-files-o'
      conditions:                'fa-stethoscope'
      devices:                   'fa-medkit'
      diagnostic_studies:        'fa-stethoscope'
      encounters:                'fa-user-md'
      functional_statuses:       'fa-stethoscope'
      interventions:             'fa-comments'
      laboratory_tests:          'fa-flask'
      medications:               'fa-medkit'
      physical_exams:            'fa-user-md'
      procedures:                'fa-scissors'
      risk_category_assessments: 'fa-user'
      care_goals:                'fa-sliders'

    @types = []
    for key, value of @result
      if key == 'Patient'
        continue
      type = switch
        when Array.isArray(value) then 'array'
        when typeof value == 'boolean' then 'boolean'
        else 'literal'
      if type == 'array'
        for item in value # Format start and stop times for displaying.
          if typeof item.entry.start_time == 'number'
            item.entry.start_time = moment.utc(item.entry.start_time, 'X').format('L LT')
          if typeof item.entry.end_time == 'number'
            item.entry.end_time = moment.utc(item.entry.end_time, 'X').format('L LT')
      dataCriteria = {}
      dataCriteria['name'] = key
      dataCriteria['type'] = type
      # If this object resolves to an array, make sure the bonnie_type is set
      # to the name of the icon used for displaying this type.
      if value instanceof Array
        for dc in value
          dc.bonnie_type = @icons[dc.bonnie_type] if @icons[dc.bonnie_type]?
      dataCriteria['value'] = value
      dataCriteria['id'] = key.replace(/[^\w\s!?]/g,'') # Remove all special characters
      @types.push dataCriteria


class Thorax.Views.CQLResultsView extends Thorax.Views.BonnieView

  template: JST['cql/cql_results_view']

  events:
    rendered: ->
      @collapsedId = @parent.collapsedId
      if @collapsedId == null # If no saved state exists, expand first div.
        $("#" + @collection.models[0].id).collapse(toggle: true)
      else
        $("#" + @collapsedId).collapse(toggle: true)
      # Event listener to set current collapsedId
      $('.panel-group').on 'shown.bs.collapse', (e) =>
        @parent.collapsedId = e.target.id

  initialize: ->
    @collection.on 'add remove change', =>
      @render()

  context: ->
    # We use the list of patients for the header
    patients = @collection.models
    _(super).extend patients: patients
