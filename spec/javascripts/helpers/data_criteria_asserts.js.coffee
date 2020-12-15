# Defines a list of assert methods for data attributes testing
@DataCriteriaAsserts = class DataCriteriaAsserts
  @assertCodingWithType: (resourceType, path, title, type) ->
    attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES[resourceType]
    expect(attrs).toBeDefined
    attr = attrs.find (attr) => attr.path is path
    expect(attr.path).toBe path
    expect(attr.title).toBe title
    expect(attr.types.length).toBe 1
    expect(attr.types[0]).toBe type

    fhirResource = new cqm.models[resourceType]()
    expect(attr.getValue(fhirResource)).toBeUndefined

    valueToSet = new cqm.models.Coding()
    valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
    valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')

    attr.setValue(fhirResource, valueToSet)

    # clone the resource to make sure setter/getter work with correct data type
    value = attr.getValue(fhirResource.clone())
    expect(value).toBeDefined
    expect(value.code.value).toBe 'code1'
    expect(value.system.value).toBe 'system1'

  @assertCodeableConcept: (resourceType, path, title) ->
    @assertCodingWithType(resourceType, path, title, 'CodeableConcept')

  @assertCoding: (resourceType, path, title) ->
    @assertCodingWithType(resourceType, path, title, 'Coding')

  @assertCode: (resourceType, path, title, customAssert) ->
    attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES[resourceType]
    expect(attrs).toBeDefined
    attr = attrs.find (attr) => attr.path is path
    expect(attr).toBeDefined
    expect(attr.path).toBe path
    expect(attr.title).toBe title
    expect(attr.types.length).toBe 1
    expect(attr.types[0]).toBe 'Code'

    fhirResource = new cqm.models[resourceType]()
    expect(attr.getValue(fhirResource)).toBeUndefined

    valueToSet = 'a code'
    attr.setValue(fhirResource, valueToSet)

    if customAssert?
      expect(customAssert(fhirResource)).toBe true

    # clone the resource to make sure setter/getter work with correct data type
    value = attr.getValue(fhirResource.clone())
    expect(value).toBeDefined
    expect(value).toBe 'a code'

  @assertPeriod: (resourceType, path, title) ->
    attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES[resourceType]
    attr = attrs.find (attr) => attr.path is path
    expect(attr.path).toEqual path
    expect(attr.title).toEqual title
    # Create fhir resource and Period
    fhirResource = new cqm.models[resourceType]()
    period = new cqm.models.Period()
    period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
    period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
    # set Period
    attr.setValue(fhirResource, period)

    value = attr.getValue(fhirResource.clone())
    # Verify after setting values
    expect(value.start.value).toEqual period.start.value
    expect(value.end.value).toEqual period.end.value
