describe 'Patient', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    patients = []
    patients.push(getJSONFixture('fhir_patients/CMS1010V0/john_smith.json'))
    collection = new Thorax.Collections.Patients patients, parse: true
    @patient = collection.first()

  it 'has basic attributes available', ->
    expect(@patient.get('cqmPatient').fhir_patient.gender.value).toEqual 'unknown'

  it 'correctly performs deep cloning', ->
    clone = @patient.deepClone()
    expect(clone.cid).not.toEqual @patient.cid
    expect(clone.keys()).toEqual @patient.keys()
    # I am not convinced that the sdc collection needs a CID, it's not getting set on initialization
    # expect(clone.get('source_data_criteria').cid).not.toEqual @patient.get('source_data_criteria').cid
    expect(clone.get('source_data_criteria').pluck('id')).toEqual @patient.get('source_data_criteria').pluck('id')
    cloneNewId = @patient.deepClone(new_id: true)
    expect(cloneNewId.cid).not.toEqual @patient.cid
    expect(cloneNewId.get('cqmPatient').id.toString()).not.toEqual @patient.get('cqmPatient').id.toString()

  it 'correctly deduplicates the name when deep cloning and dedupName is an option', ->
    clone = @patient.deepClone({dedupName: true})
    expect(clone.getFirstName()).toEqual @patient.getFirstName() + " (1)"

  it 'exports patient to bundle object', ->
    cqmPatient = new Thorax.Models.Patient getJSONFixture('fhir_patients/CMS124/bonnie-patient.json'), parse: true
    bundle = cqmPatient.toBundle()
    expect(bundle).toBeDefined()
    expect(bundle).not.toBeNull()
    expect(bundle.id).toBe(cqmPatient.get("id"))
    expect(bundle.entry).toBeDefined()
    expect(bundle.entry).not.toBeNull()
    expect(bundle.entry.length).toBe(6)

    expect(bundle.entry[0].resource.resourceType).toBe('Patient')
    expect(bundle.entry[0].resource.identifier[0].type.coding[0].system).toBe("http://terminology.hl7.org/CodeSystem/v2-0203");
    expect(bundle.entry[0].resource.identifier[0].type.coding[0].code).toBe("MR");
    expect(bundle.entry[0].resource.identifier[0].value).toBe(cqmPatient.get("id"));
    expect(bundle.entry[0].resource.meta.profile[0]).toBe("http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-patient");

    expect(bundle.entry[1].resource.resourceType).toBe('Encounter')
    expect(bundle.entry[2].resource.resourceType).toBe('Encounter')
    expect(bundle.entry[3].resource.resourceType).toBe('Encounter')
    expect(bundle.entry[4].resource.resourceType).toBe('Encounter')
    expect(bundle.entry[5].resource.resourceType).toBe('Encounter')
#    expect(bundle.entry[6].resourceType).toBe('MeasureReport')
#    measureReport = bundle.entry[6]
#    expect(measureReport.group.length).toBe(1)
#    measureReportGroup = measureReport.group[0]
#    expect(measureReportGroup.population.length).toBe(4)
#    expect(measureReportGroup.population[0].count).toBe(1)
#    expect(measureReportGroup.population[0].code.coding[0].code.value).toBe("initial-population")
#    expect(measureReportGroup.population[1].count).toBe(0)
#    expect(measureReportGroup.population[1].code.coding[0].code.value).toBe("denominator")
#    expect(measureReportGroup.population[2].count).toBe(0)
#    expect(measureReportGroup.population[2].code.coding[0].code.value).toBe("denominator-exclusion")
#    expect(measureReportGroup.population[3].count).toBe(0)
#    expect(measureReportGroup.population[3].code.coding[0].code.value).toBe("numerator")

  xit 'skips STRAT groups when exporting to bundle', ->
    cqmPatient = new Thorax.Models.Patient getJSONFixture('fhir_patients/CMS111/strat-patient.json'), parse: true
    bundle = cqmPatient.toBundle()
    expect(bundle).toBeDefined()
    expect(bundle).not.toBeNull()
    expect(bundle.id).toBe(cqmPatient.get("id"))
    expect(bundle.entry).toBeDefined()
    expect(bundle.entry).not.toBeNull()
    measureReport = bundle.entry[4]
    expect(measureReport.group.length).toBe(2)
    expect(measureReport.group[0].population.length).toBe(3)
    expect(measureReport.group[1].population.length).toBe(3)

  it 'updates patient race', ->
    race = {code: '2106-3', display: 'White'}
    @patient.setCqmPatientRace(race)
    raceExt = @patient.get('cqmPatient').fhir_patient.extension.find (ext) ->
      ext.url.value == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'
    expect(raceExt.extension[0].value.code.value).toEqual race.code
    expect(raceExt.extension[0].value.display.value).toEqual race.display

  it 'updates patient ethnicity', ->
    ethnicity = {code: '2186-5', display: 'Not Hispanic or Latino'}
    @patient.setCqmPatientEthnicity(ethnicity)
    ethnicityExt = @patient.get('cqmPatient').fhir_patient.extension.find (ext) ->
      ext.url.value == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'
    expect(ethnicityExt.extension[0].value.code.value).toEqual ethnicity.code
    expect(ethnicityExt.extension[0].value.display.value).toEqual ethnicity.display

  # it 'correctly sorts criteria by multiple attributes', ->
  #   # Patient has for existing criteria; first get their current order
  #   startOrder = @patient1.get('source_data_criteria').map (dc) -> dc.cid
  #   # Set some attribute values so that they should sort 4,3,2,1 and sort
  #   @patient1.get('source_data_criteria').at(0).set start_date: 2, end_date: 2
  #   @patient1.get('source_data_criteria').at(1).set start_date: 2, end_date: 1
  #   @patient1.get('source_data_criteria').at(2).set start_date: 1, end_date: 3
  #   @patient1.get('source_data_criteria').at(3).set start_date: 1, end_date: 2
  #   @patient1.sortCriteriaBy 'start_date', 'end_date'
  #   expect(@patient1.get('source_data_criteria').at(0).cid).toEqual startOrder[3]
  #   expect(@patient1.get('source_data_criteria').at(1).cid).toEqual startOrder[2]
  #   expect(@patient1.get('source_data_criteria').at(2).cid).toEqual startOrder[1]
  #   expect(@patient1.get('source_data_criteria').at(3).cid).toEqual startOrder[0]

  describe 'validation', ->

    it 'passes patient with no issues', ->
      errors = @patient.validate()
      expect(errors).toBeUndefined()

    it 'fails patient missing a first name', ->
      clone = @patient.deepClone()
      clone.get('cqmPatient').fhir_patient.name[0].given[0].value = ''
      errors = clone.validate()
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Name fields cannot be blank'

    it 'fails patient missing a last name', ->
      clone = @patient.deepClone()
      clone.get('cqmPatient').fhir_patient.name[0].family.value = ''
      errors = clone.validate()
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Name fields cannot be blank'

    it 'fails patient missing a birthdate', ->
      clone = @patient.deepClone()
      clone.get('cqmPatient').fhir_patient.birthDate.value = undefined
      errors = clone.validate()
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Date of birth cannot be blank'

    it 'initializes false populations in getExpectedValues', ->
      measure = new Thorax.Models.Measure({set_id: 1}, {parse: true})
      targetPopulationSets = new Thorax.Collections.PopulationSets [], parent: measure
      targetPopulationSets.add new Thorax.Models.PopulationSet({populations: {IPP: 0, MSRPOPL: 0, MSRPOPLEX: 0}}, {parse: true})
      targetPopulation = targetPopulationSets.first()
      expectedValue = @patient.getExpectedValue(targetPopulation)
      expect(expectedValue).toBeDefined
      expect(expectedValue.IPP).toBeDefined
      expect(expectedValue.MSRPOPL).toBeDefined
      expect(expectedValue.MSRPOPLEX).toBeDefined
      expect(expectedValue.has('IPP')).toBe false
      expect(expectedValue.has('MSRPOPL')).toBe false
      expect(expectedValue.has('MSRPOPLEX')).toBe false

    # it 'fails deceased patient without a deathdate', ->
    #   clone = @patient.deepClone()
    #   (clone.get('cqmPatient').qdmPatient.patient_characteristics().filter (elem) -> elem.qdmStatus == 'expired')[0].expiredDatetime = undefined
    #   errors = clone.validate()
    #   expect(errors.length).toEqual 1
    #   expect(errors[0][2]).toEqual 'Deceased patient must have date of death'
