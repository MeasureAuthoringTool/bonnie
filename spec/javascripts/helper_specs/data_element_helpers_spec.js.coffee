describe 'DataElementHelpers', ->
  it 'returns undefined (unsupported) for an empty DataElement getPrimaryCodePath', ->
    expect(DataElementHelpers.getPrimaryCodePath(new cqm.models.DataElement())).toBeUndefined

  it 'returns undefined for a DataElement unknown resource', ->
    de = new cqm.models.DataElement()
    de.fhir_resource = new cqm.models.Resource()
    de.fhir_resource.resourceType = 'unsupported'
    expect(DataElementHelpers.getPrimaryCodePath(de)).toBeUndefined()

  it 'returns meta for getPrimaryCodePath', ->
    for res in DataElementHelpers.DATA_ELEMENT_PRIMARY_CODE_PATH
        de = new cqm.models.DataElement()
        de.fhir_resource = new cqm.models[res]()
        expect(DataElementHelpers.getPrimaryCodePath(de)).toBeDefined()

  it 'works for Encounter', ->
    de = new cqm.models.DataElement()
    de.fhir_resource = new cqm.models.Encounter()
    expect(DataElementHelpers.getPrimaryCodePath(de).path).toEqual 'type'
    expect(DataElementHelpers.getPrimaryCodePath(de).array).toBe true
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
    expect(DataElementHelpers.getPrimaryCodePath(de).path).toEqual 'code'
    expect(DataElementHelpers.getPrimaryCodePath(de).array).toBe false
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
