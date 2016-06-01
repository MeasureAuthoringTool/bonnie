class PatientSource
  constructor: (@patients) -> @index = 0
  currentPatient: -> new CQL_QDM.CQLPatient(@patients.at(@index)) if @patients.at(@index)
  nextPatient: -> @index += 1

class Thorax.Views.CQLPlaygroundView extends Thorax.Views.BonnieView

  template: JST['cql/cql_playground']

  initialize: ->
    @resultCollection = new Thorax.Collection()
    @collection.each (patient) =>
      @resultCollection.add(new Thorax.Model(id: patient.id, first: patient.get('first'), last: patient.get('last'), results: {}))
    @resultsView = new Thorax.Views.CQLResultsView(collection: @resultCollection)

  events:
    "ready": ->
      @$('#cqlPlayground').modal(backdrop: 'static', show: true)
      @editor = ace.edit("editor")
      @editor.setTheme("ace/theme/chrome")
      @editor.session.setMode("ace/mode/cql_highlight_rules")
      @editor.setShowPrintMargin(false)
      $("#cqlPlayground").on 'hide.bs.modal', ->
        $('#editor').remove()

  evaluateCql: ->
    cql = @editor.getValue()
    post = $.post "measures/cql_to_elm", { cql: cql, authenticity_token: $("meta[name='csrf-token']").attr('content') }
    post.done (response) => @updateElm(response)
    post.fail (response) => @displayErrors(response)
    @editor.focus()

  updateElm: (elm) ->
    @editor.getSession().clearAnnotations()
    patientSource = new PatientSource(@collection)
    results = executeSimpleELM(elm, patientSource, @valueSetsForCodeService())
    @resultCollection.each (patient) => patient.set(results: results.patientResults[patient.id])

  displayErrors: (response) ->
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


class Thorax.Views.CQLResultView extends Thorax.Views.BonnieView
  template: JST['cql/cql_result_view']

  initialize: ->
    @description = ''
    for k, v of @result
      @description += k + ': ' + v + '\n'



class Thorax.Views.CQLResultsView extends Thorax.Views.BonnieView

  template: JST['cql/cql_results_view']

  initialize: ->
    # Perform a full re-render on collection update since we don't use collection template helpers
    @collection.on 'add remove change', => @render()

  context: ->
    # We use the list of patients for the header
    patients = @collection.models
    _(super).extend patients: patients
