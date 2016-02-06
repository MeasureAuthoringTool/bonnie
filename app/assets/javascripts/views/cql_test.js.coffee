class WrappedEntry
  constructor: (@entry) ->
    # Set some field values for display; these aren't used for calculation
    @description = @entry.description
    @startTime = moment.utc(@entry.start_time, 'X').format('L LT')
    @stopTime = moment.utc(@entry.end_time, 'X').format('L LT')
  getCode: ->
    allCodes = []
    for system, codes of @entry.codes
      for code in codes
        allCodes.push code: code, system: system
    allCodes
  get: (attribute) ->
    switch attribute
      when 'start datetime', 'admission datetime', 'onset datetime'
        return cql.DateTime.fromDate(moment.utc(@entry.start_time, 'X').toDate())
      when 'stop datetime', 'discharge datetime', 'abatement datetime'
        return cql.DateTime.fromDate(moment.utc(@entry.end_time, 'X').toDate())
      when 'discharge status'
        if @entry.dischargeDisposition
          return new cql.Code(@entry.dischargeDisposition.code, @entry.dischargeDisposition.code_system)
      else
        console.log "Requesting unknown attribute #{attribute} from entry"

class WrappedPatient
  constructor: (@patient) ->
  id: -> @patient.id
  findRecords: (profile) ->
    switch profile
      when 'Patient'
        [{ 'birth datetime': cql.DateTime.fromDate(moment.utc(@patient.get('birthdate'), 'X').toDate()) }]
      when 'DiagnosisActive', 'Diagnosis'
        _(@patient.get('conditions')).map (c) -> new WrappedEntry(c)
      when 'EncounterPerformed'
        _(@patient.get('encounters')).map (e) -> new WrappedEntry(e)
      when 'MedicationDischarge'
        _(@patient.get('medications')).map (m) -> new WrappedEntry(m)
      else
        console.log "Requesting unknown profile #{profile} from patient"

class PatientSource
  constructor: (@patients) -> @index = 0
  currentPatient: -> new WrappedPatient(@patients.at(@index)) if @patients.at(@index)
  nextPatient: -> @index += 1


# View representing a single CQL result; this can be a literal, an element, an array of elements, etc
class Thorax.Views.CQLResultView extends Thorax.Views.BonnieView
  template: JST['cql/cql_result']
  events:
    rendered: ->
      popoverContent = @$('.cql-entry-details').html()
      @$('.cql-entry').popover trigger: 'hover', placement: 'left', title: "Details", html: true, content: popoverContent
  initialize: ->
    @type = switch
      when @result instanceof WrappedEntry then 'entry'
      when Array.isArray(@result) then 'array'
      when typeof @result == 'boolean' then 'boolean'
      else 'literal'

# View representing a table of CQL results
class Thorax.Views.CqlResultsView extends Thorax.Views.BonnieView

  template: JST['cql/cql_results']

  initialize: ->
    # Perform a full re-render on collection update since we don't use collection template helpers
    @collection.on 'add remove change', => @render()

  context: ->
    # We use the list of patients for the header
    patients = @collection.map (p) -> "#{p.get('last')}, #{p.get('first')}"
    # Assume all patients have same fields, so we can extract statement names from the results in the first
    results = if patient = @collection.first() then patient.get('results') else {}
    # For the body, each row represents a statement and the results for that statement for each patient
    statements = _(results).chain().omit('Patient').keys().value()
    rows = _(statements).map (s) => { statement: s, results: @collection.map (p) -> p.get('results')[s] }
    _(super).extend patients: patients, rows: rows


class Thorax.Views.CqlTestView extends Thorax.Views.BonnieView

  template: JST['cql/cql_test']

  initialize: ->
    @resultCollection = new Thorax.Collection()
    @collection.each (patient) =>
      @resultCollection.add(new Thorax.Model(id: patient.id, first: patient.get('first'), last: patient.get('last'), results: {}))
    @resultsView = new Thorax.Views.CqlResultsView(collection: @resultCollection)

  events:
    "ready": ->
      @$('#cqlTestDialog').modal(backdrop: 'static', show: true)
    "submit form": (event) ->
      event.preventDefault()
      cql = @$('textarea').val()
      post = $.post "measures/cql_to_elm", { cql: cql, authenticity_token: $("meta[name='csrf-token']").attr('content') }
      post.done (response) => @updateElm(response)
      post.fail (response) => @displayErrors(response)

  updateElm: (elm) ->
    patientSource = new PatientSource(@collection)
    results = executeSimpleELM(elm, patientSource, @valueSetsForCodeService())
    @resultCollection.each (patient) => patient.set(results: results.patientResults[patient.id])

  displayErrors: (response) ->
    switch response.status
      when 500
        alert "CQL translation error: #{response.statusText}"
      when 400
        errors = response.responseJSON.library.annotation.map (annotation) -> "Line #{annotation.startLine}: #{annotation.message}"
        alert "Errors:\n\n#{errors.join("\n\n")}"

  valueSetsForCodeService: ->
    valueSetsForCodeService = {}
    for oid, vs of bonnie.valueSetsByOid
      continue unless vs.concepts
      valueSetsForCodeService[oid] ||= {}
      valueSetsForCodeService[oid][vs.version] ||= []
      for concept in vs.concepts
        valueSetsForCodeService[oid][vs.version].push code: concept.code, system: concept.code_system_name, version: vs.version
    valueSetsForCodeService

  snippets: ->
    [
      "library TinyQDM version '4'"
      "using QDM"
      ""
      """valueset "Ischemic Stroke": '2.16.840.1.113883.3.117.1.7.1.247'"""
      """valueset "Inpatient Encounter": '2.16.840.1.113883.3.464.1003.101.12.1060'"""
      """valueset "Antithrombotic Therapy": '2.16.840.1.113883.3.117.1.7.1.201'"""
      """valueset "Left Against Medical Advice": '2.16.840.1.113883.3.3157.1002.22'"""
      ""
      "parameter MeasurementPeriod default Interval[DateTime(2012, 1, 1, 0, 0, 0, 0), DateTime(2013, 1, 1, 0, 0, 0, 0))"
      "context Patient"
      ""
      "define OverEighteen: AgeInYearsAt(start of MeasurementPeriod) >= 18"
      ""
      "// Inpatient encounters during the Measurement Period"
      "define Encounters:"
      """  ["Encounter, Performed": "Inpatient Encounter"] E where E."admission datetime" during MeasurementPeriod"""
      ""
      """define IschemicStroke: ["Diagnosis": "Ischemic Stroke"]"""
      ""
      "// Inpatient encounters where an ischemic stroke was diagnosed"
      "define EncountersWithIschemicStroke:"
      """  Encounters E with IschemicStroke D such that Interval[E."admission datetime", E."discharge datetime"] includes D."onset datetime\""""
      ""
      "define Denominator: OverEighteen and Count(EncountersWithIschemicStroke) > 0"
      ""
      "// Discharged on antithrombotic therapy during an encounter with a stroke diagnosis"
      "define MedicationDuringEncounter:"
      """  ["Medication, Discharge": "Antithrombotic Therapy"] M with EncountersWithIschemicStroke E"""
      """  such that Interval[E."admission datetime", E."discharge datetime"] includes M."start datetime\""""
      ""
      "define Numerator: Count(MedicationDuringEncounter) > 0"
      ""
      "// Encounters where the patient left against medical advice"
      "define EncountersWherePatientLeft:"
      """EncountersWithIschemicStroke E where E."discharge status" in "Left Against Medical Advice\""""
      ""
      "define DenominatorExclusions: Count(EncountersWherePatientLeft) > 0"
    ]

  addSnippet1: ->
    @$('textarea').val(@snippets().slice(0, 13).join("\n"))

  addSnippet2: ->
    @$('textarea').val(@snippets().slice(0, 17).join("\n"))

  addSnippet3: ->
    @$('textarea').val(@snippets().slice(0, 25).join("\n"))

  addSnippet4: ->
    @$('textarea').val(@snippets().slice(0, 32).join("\n"))

  addSnippet5: ->
    @$('textarea').val(@snippets().join("\n"))
