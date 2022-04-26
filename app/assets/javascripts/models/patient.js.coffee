class Thorax.Models.Patient extends Thorax.Model
  idAttribute: 'id'
  urlRoot: '/patients'

  parse: (attrs) ->
    thoraxPatient = {}
    thoraxPatient.id = attrs.id
    # cqmPatient will already exist if we are cloning the thoraxModel
    if attrs.cqmPatient?
      thoraxPatient.cqmPatient = cqm.models.CqmPatient.parse(attrs.cqmPatient)
      # thoraxPatient.cqmPatient.fhir_patient.extendedData = attrs.cqmPatient.fhir_patient.extendedData
    else
      thoraxPatient.cqmPatient = cqm.models.CqmPatient.parse(attrs)
    if !thoraxPatient.cqmPatient.fhir_patient
      thoraxPatient.cqmPatient.fhir_patient = new cqm.models.Patient()
      thoraxPatient.cqmPatient.fhir_patient.id = thoraxPatient.id
      thoraxPatient.cqmPatient.fhir_patient.name = [ new cqm.models.HumanName() ]
    thoraxPatient.expired = !!thoraxPatient.cqmPatient.fhir_patient.deceased?.value
    thoraxPatient.source_data_criteria = new Thorax.Collections.SourceDataCriteria(thoraxPatient.cqmPatient.data_elements, parent: this, parse: true)
    thoraxPatient.expected_values = new Thorax.Collections.ExpectedValues(thoraxPatient.cqmPatient.expected_values, parent: this, parse: true)
    thoraxPatient

  # Create a deep clone of the patient, optionally omitting the id field
  deepClone: (options = {}) ->
    clonedPatient = @.clone()
    # clone the cqmPatient and make a new source_data_criteria collection for it
    clonedPatient.set 'cqmPatient', clonedPatient.get('cqmPatient').clone()
    if options.new_id || !clonedPatient.get('cqmPatient').id
      clonedPatient.get('cqmPatient').id = cqm.ObjectID().toHexString()
      clonedPatient.get('cqmPatient').fhir_patient.id = clonedPatient.get('cqmPatient').id
    clonedPatient.set 'id', clonedPatient.get('cqmPatient')?.id
    clonedPatient.set 'source_data_criteria', new Thorax.Collections.SourceDataCriteria(clonedPatient.get('cqmPatient').data_elements, parent: clonedPatient, parse: true)
    clonedPatient.set 'expected_values', new Thorax.Collections.ExpectedValues(clonedPatient.get('cqmPatient').expected_values, parent: clonedPatient, parse: true)
    if options.dedupName
      clonedPatient.get('cqmPatient').fhir_patient.name[0].given[0].value = bonnie.patients.dedupName(clonedPatient)
    clonedPatient

  getValidMeasureIds: (measures) ->
    validIds = {}
    @get('cqmPatient')['measure_ids'].map (m) ->
      validIds[m] = {key: m, value: _.contains(measures.pluck('set_id'), m)}
    validIds
  getEntrySections: ->
    s for s in Thorax.Models.Patient.sections when @has(s)
  ### Patient HTML Header values ###
  getBirthDate: -> @printDate @get('cqmPatient').fhir_patient.birthDate?.value
  getDeathDateTimeValue: ->
    # fhir-typescript-models/src/models/fhir/classes/Patient.ts
    #   public deceased?: PrimitiveBoolean | PrimitiveDateTime;
    val = @get('cqmPatient').fhir_patient.deceased?.value
    if typeof val != 'boolean' then val

  getDeathDate: -> @printDate @getDeathDateTimeValue()
  getDeathTime: -> @printTime @getDeathDateTimeValue()

# Next 4 methods return the Code object since some calls to them need the code while others need the display name
  getGender: ->
    genderElement = (@get('cqmPatient')).fhir_patient.gender
    {code: genderElement?.value, display: genderElement?.value}

  getRace: ->
    raceExt = @get('cqmPatient').fhir_patient.extension?.find (ext) ->
      ext.url.value == "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"
    {code: raceExt?.extension?[0]?.value?.code?.value, display: raceExt?.extension?[0]?.value?.display?.value}

  getEthnicity: ->
    ethnicityExt = @get('cqmPatient').fhir_patient.extension?.find (ext) ->
      ext.url.value == "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity"
    {code: ethnicityExt?.extension?[0]?.value?.code?.value, display: ethnicityExt?.extension?[0]?.value?.display?.value}

  getPayer: ->
# TODO
#    payerElement = (@get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'payer')[0]
#    unless payerElement? then return {code: "Unknown", display: "Unknown"}
#    else unless payerElement.dataElementCodes[0].display? then "CDC-RE: #{payerElement.dataElementCodes[0].code}"
#    else payerElement.dataElementCodes[0]
    {code: "Unknown", display: "Unknown"}

  getInsurance: ->
    insurances = @get('insurance_providers')?.map (ip) -> ip.name
    insurances?.join(", ") or ''
  getFirstName: ->
    @get('cqmPatient').fhir_patient.name[0].given?.map((v) => v.value).join(' ') || ''
  getLastName: ->
    @get('cqmPatient').fhir_patient.name[0].family?.value || ''
  getNotes: ->
    @get('cqmPatient').notes
  getAddresses: ->
    address = ""
    if @get('addresses')
      for addr in @get('addresses')
        for street in addr.street
          address += street + "\n"
        address += addr.city + ", " + addr.state + ", " + addr.zip + "\n"
        if addr.use
          address += addr.use + "\n"
    if @get('telecoms')
      for telecom in @get('telecoms')
        address += telecom.value + "\n"
        if telecom.use
          address += telecom.use + "\n"
  setCqmPatientFirstName: (firstName) ->
    @get('cqmPatient').fhir_patient.name[0].given = [ cqm.models.PrimitiveString.parsePrimitive(firstName) ]
  setCqmPatientLastName: (lastName) ->
    @get('cqmPatient').fhir_patient.name[0].family = cqm.models.PrimitiveString.parsePrimitive(lastName)

  setCqmPatientNotes: (notes) ->
    @get('cqmPatient').notes = notes

  setCqmPatientBirthDate: (birthdate, measure) ->
    string_date = moment.utc(birthdate, 'L').format("YYYY-MM-DD")
    @get('cqmPatient').fhir_patient.birthDate = cqm.models.PrimitiveDate.parsePrimitive(string_date)

  setCqmPatientDeceased: (deathdate, measure) ->
    string_date = moment.utc(deathdate, "L LT").toISOString()
    @get('cqmPatient').fhir_patient.deceased = cqm.models.PrimitiveDateTime.parsePrimitive(string_date)


  setCqmPatientGender: (gender, measure) ->
    @get('cqmPatient').fhir_patient.gender = cqm.models.AdministrativeGender.parsePrimitive(gender)

  setCqmPatientRace: (race) ->
    @get('cqmPatient').fhir_patient.extension = [] unless @get('cqmPatient').fhir_patient.extension

    @get('cqmPatient').fhir_patient.extension = @get('cqmPatient').fhir_patient.extension.filter (ext) ->
      ext.url.value != "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"

    # Build and assign new race extension to fhir_patient
    newRaceExtension = cqm.models.Extension.parse({
      url: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"
      extension: [
        {
          url: 'ombCategory'
          valueCoding: {
            system: 'urn:oid:2.16.840.1.113883.6.238'
            code: race.code
            display: race.display
            userSelected: true
          }
        },
        {
          url: "text",
          valueString: race.display
        }
      ]
    })
    @get('cqmPatient').fhir_patient.extension.push(newRaceExtension)

  setCqmPatientEthnicity: (ethnicity) ->
    @get('cqmPatient').fhir_patient.extension = [] unless @get('cqmPatient').fhir_patient.extension
    # retain non ethnicity extensions
    @get('cqmPatient').fhir_patient.extension = @get('cqmPatient').fhir_patient.extension.filter (ext) ->
      ext.url.value != "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity"

    # Build and assign new ethnicity extension to fhir_patient
    newEthnicityExtension = cqm.models.Extension.parse({
      url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'
      extension: [
        {
          url: 'ombCategory'
          valueCoding: {
            system: "urn:oid:2.16.840.1.113883.6.238"
            code: ethnicity.code
            display: ethnicity.display
            userSelected: true
          }
        },
        {
          url: 'text'
          valueString: ethnicity.display
        }
      ]
    })
    @get('cqmPatient').fhir_patient.extension.push(newEthnicityExtension)

  removeElementAndGetNewCopy: (elementType, cqmMeasure) ->
    element = (@get('cqmPatient').data_elements?.filter (elem) -> elem.fhir_resource?.resourceType == elementType)[0]
    if element
      elementIndex = @get('cqmPatient').data_elements.indexOf(element)
      @attributes.cqmPatient.data_elements.splice(elementIndex, 1)
#    # return copy of dataElement off the measure if one exists
    sdcDataElement = (cqmMeasure?.source_data_criteria?.filter (elem) -> elem.fhir_resource?.resourceType == elementType)[0]
    if (sdcDataElement)
      return sdcDataElement.clone()
    else
      return null

  getConceptsForPatientProp: (prop, measure) ->
    valueSet = measure.valueSets()?.find (elem) -> elem.title == prop
    valueSet?.compose?.include?[0]?.concept || []

  getConceptsForDataElement: (qdmStatus, measure) ->
    return [] unless measure.get('cqmMeasure')?.source_data_criteria?
    dataCriteria = (measure.get('cqmMeasure').source_data_criteria.filter (elem) -> elem.qdmStatus == qdmStatus)[0]
    return [] unless dataCriteria?
    valueSet = (measure.valueSets()?.filter (elem) -> elem.oid == dataCriteria.codeListId)?[0]
    valueSet?.concepts || []

  createCQLDate: (date) ->
    cqm.models.CQL.DateTime.fromJSDate(date, 0)

  conceptToCode: (concept) ->
    new cqm.models.CQL.Code(concept.code, concept.code_system_oid, null, concept.display_name || null)

  printDate: (date) ->
    moment(date, "YYYY-MM-DD").format("MM/DD/YYYY") if date

  printTime: (dateTime) ->
    moment(dateTime, "YYYY-MM-DDTHH:mm:ss").format('h:mm A') if dateTime

  materialize: ->
    @trigger 'materialize'

  getExpectedValue: (targetPopulation) ->
    measure = targetPopulation.collection.parent
    expectedValue = @get('expected_values').findWhere(measure_id: measure.get('cqmMeasure').set_id, population_index: targetPopulation.index())
    unless expectedValue
      expectedValue = new Thorax.Models.ExpectedValue measure_id: measure.get('cqmMeasure').set_id, population_index: targetPopulation.index()
      @get('expected_values').add expectedValue
    populations = targetPopulation?.get('populations')
    # Initialize expected values with 0
    # We don't want to set a value for OBSERV, it should already exist or be created in the builder
    for populationCriteria in Thorax.Models.Measure.allPopulationCodes when populations.hasOwnProperty(populationCriteria) and populationCriteria != 'OBSERV'
      expectedValue.set populationCriteria, 0 unless expectedValue.has populationCriteria

    if !_(@get('cqmPatient')['measure_ids']).contains measure.get('cqmMeasure').set_id # if patient wasn't made for this measure
      expectedValue.set _.object(_.keys(expectedValue.attributes), []) # make expectations undefined instead of 0/fail

    expectedValue

  getExpectedValues: (measure) ->
    expectedValues = new Thorax.Collections.ExpectedValues([], parent: this)
    measure.get('populations').each (population) =>
      expectedValues.add @getExpectedValue(population)
    expectedValues

  # Sort criteria by any number of attributes, first given highest priority
  sortCriteriaBy: (attributes...) ->
    originalComparator = @get('source_data_criteria').comparator
    @get('source_data_criteria').comparator = (crit) -> _(attributes).map((attr) -> crit.get(attr))
    @get('source_data_criteria').sort()
    @get('source_data_criteria').comparator = originalComparator

  validate: ->
    errors = []
    birthdate = if @get('cqmPatient').fhir_patient.birthDate?.value then moment(@get('cqmPatient').fhir_patient.birthDate.value, "YYYY-MM-DD") else null
    dd = @getDeathDateTimeValue()
    deathdate = if dd then moment(dd, "YYYY-MM-DD") else null
    unless @getFirstName()?.length > 0
      errors.push [@cid, 'first', 'Name fields cannot be blank']
    unless @getLastName()?.length > 0
      errors.push [@cid, 'last', 'Name fields cannot be blank']
    unless birthdate
      errors.push [@cid, 'birthdate', 'Date of birth cannot be blank']
    if birthdate && birthdate.year() < 1000
      errors.push [@cid, 'birthdate', 'Date of birth must have four digit year']
    if deathdate && deathdate.year() < 1000
      errors.push [@cid, 'deathdate', 'Date of death must have four digit year']
    if deathdate && birthdate && deathdate.isBefore birthdate
      errors.push [@cid, 'deathdate', 'Date of death cannot be before date of birth']

    return errors if errors.length > 0

  populationMappings =
    IPP:
      code: "initial-population"
      display:  "Initial Population"
    NUMER:
      code: "numerator"
      display:  "numerator"
    NUMEX:
      code: "numerator-exclusion"
      display:  "Numerator Exclusion"
    DENOM:
      code: "denominator"
      display:  "Denominator"
    DENEX:
      code: "denominator-exclusion"
      display:  "Denominator Exclusion"
    DENEXCEP:
      code: "denominator-exception"
      display:  "Denominator Exception"
    MSRPOPL:
      code: "measure-population"
      display:  "Measure Population"
    MSRPOPLEX:
      code: "measure-population-exclusion"
      display:  "Measure Population Exclusion"
    OBSERV:
      code: "measure-observation"
      display:  "Measure Observation"

  toBundle: () ->
    cqmPatient = @get('cqmPatient')
    bundle = cqm.execution.Calculator.convertPatientToBundle(cqmPatient)
    groups = cqmPatient.expected_values?.map (expected_value) ->
      group = {};
      populations = []
      for k,v of expected_value
        population = {}
        continue if !populationMappings[k]
        coding = cqm.models.Coding.parse(populationMappings[k]);
        population.code = cqm.models.CodeableConcept.parse({coding: [populationMappings[k]]})
        population.count = v
        mPop = cqm.models.MeasureReportGroupPopulation.parse(population);
        populations.push(population)
      group.id = "group-#{expected_value.population_index}"
      group.population = populations
      measureReportGroup = cqm.models.MeasureReportGroup.parse(group);
      group
    measureReport = cqm.models.MeasureReport.parse({
      type: "individual", date: new Date(),
      text: {status: "additional", div: cqmPatient.notes},
    })
    measureReportJson = measureReport.toJSON()
    measureReportJson.group = groups;
    bundleJson = bundle.toJSON();
    bundleJson.entry.push(measureReportJson);
    bundleJson

class Thorax.Collections.Patients extends Thorax.Collection
  url: '/patients'
  model: Thorax.Models.Patient
  dedupName: (patient) ->
    # Can't use patient getters here since patient is not a thorax patient at this point
    patientFirst = patient.getFirstName()
    patientLast = patient.getLastName()
    return patientFirst if !(patientFirst && patientLast)
    # matcher to find all of the records that have the same last name and the first name starts with the first name of the
    # patient data being duplicated
    matcher =  (record) ->
      return false if !(record.getFirstName() && record.getLastName()) || record.getLastName() != patientLast
      return record.getFirstName().substring( 0, patientFirst.length ) == patientFirst;

    matches = @.filter(matcher)
    index = 1
    # increment the index for any copy index that may have been previously used
    index++ while _.find(matches, (record) -> record.getFirstName() == patientFirst + " ("+index+")")
    patientFirst + " (" + index + ")"

  toOids: ->
    patientToOids = {} # patient medical_record_number : valueSet oid
    @each (p) => patientToOids[p.get('medical_record_number')] = p.get('source_data_criteria').pluck('oid')
    patientToOids

  toSdc: ->
    patientToSdc = {} # patient medical_record_number : source_data_criteria
    @each (p) => patientToSdc[p.get('medical_record_number')] = p.get('source_data_criteria').models
    patientToSdc
