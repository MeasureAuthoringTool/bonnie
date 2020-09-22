describe 'DataElementHelpers', ->

  DATA_ELEMENT_PRIMARY_CODE_PATH = [
    "AdverseEvent",
    "AllergyIntolerance",
    "Condition",
    "FamilyMemberHistory",
    "Procedure",
    "Coverage",
    "BodyStructure",
    "DiagnosticReport",
    "ImagingStudy",
    "Observation",
    "Specimen",
    "CarePlan",
    "CareTeam",
    "Goal",
    "NutritionOrder",
    "ServiceRequest",
    "Claim",
    "Communication",
    "CommunicationRequest",
    "DeviceRequest",
    "DeviceUseStatement",
    "Location",
    "Device",
    "Substance",
    "Encounter",
    "Flag",
    "Immunization",
    "ImmunizationEvaluation",
    "ImmunizationRecommendation",
    "Medication",
    "MedicationAdministration",
    "MedicationDispense",
    "MedicationRequest",
    "MedicationStatement",
    "Patient",
    "Practitioner",
    "PractitionerRole",
    "RelatedPerson",
    "Task",
  ]

  it 'returns undefined (unsupported) for an empty DataElement getPrimaryCodePath', ->
    expect(DataElementHelpers.getPrimaryCodePath(new cqm.models.DataElement())).toBeUndefined

  it 'returns null for a DataElement unknown resource', ->
    de = new cqm.models.DataElement()
    de.fhir_resource = new cqm.models.Resource()
    de.fhir_resource.resourceType = 'unsupported'
    expect(DataElementHelpers.getPrimaryCodePath(de)).toBe(null)

  it 'returns meta for getPrimaryCodePath', ->
    for res in DATA_ELEMENT_PRIMARY_CODE_PATH
        de = new cqm.models.DataElement()
        de.fhir_resource = new cqm.models[res]()
        expect(DataElementHelpers.getPrimaryCodePath(de)).toBeDefined()

  it 'works for Encounter', ->
    de = new cqm.models.DataElement()
    de.fhir_resource = new cqm.models.Encounter()
    expect(DataElementHelpers.getPrimaryCodePath(de)).toEqual 'type'
    expect(DataElementHelpers.getPrimaryCodes(de)).toEqual []
    coding = new cqm.models.Coding()
    coding.system = cqm.models.PrimitiveUri.parsePrimitive('system')
    coding.code = cqm.models.PrimitiveCode.parsePrimitive('code')
    coding.version = cqm.models.PrimitiveString.parsePrimitive('version')
    DataElementHelpers.setPrimaryCodes(de, [coding])
    expect(DataElementHelpers.getPrimaryCodes(de).length).toEqual 1
    expect(DataElementHelpers.getPrimaryCodes(de)[0].code.value).toEqual 'code'
    expect(DataElementHelpers.getPrimaryCodes(de)[0].system.value).toEqual 'system'
    expect(DataElementHelpers.getPrimaryCodes(de)[0].version.value).toEqual 'version'

  it 'works for Condition', ->
    de = new cqm.models.DataElement()
    de.fhir_resource = new cqm.models.Condition()
    expect(DataElementHelpers.getPrimaryCodePath(de)).toEqual 'code'
    expect(DataElementHelpers.getPrimaryCodes(de)).toEqual []
    coding = new cqm.models.Coding()
    coding.system = cqm.models.PrimitiveUri.parsePrimitive('system')
    coding.code = cqm.models.PrimitiveCode.parsePrimitive('code')
    coding.version = cqm.models.PrimitiveString.parsePrimitive('version')
    DataElementHelpers.setPrimaryCodes(de, [coding])
    expect(DataElementHelpers.getPrimaryCodes(de).length).toEqual 1
    expect(DataElementHelpers.getPrimaryCodes(de)[0].code.value).toEqual 'code'
    expect(DataElementHelpers.getPrimaryCodes(de)[0].system.value).toEqual 'system'
    expect(DataElementHelpers.getPrimaryCodes(de)[0].version.value).toEqual 'version'
