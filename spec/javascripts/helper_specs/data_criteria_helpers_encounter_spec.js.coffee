describe 'DataCriteriaHelpers', ->

  describe 'Encounter attributes', ->
    it 'should support Encounter.class', ->
      DataCriteriaAsserts.assertCoding('Encounter', 'class')

    it 'should support Encounter.diagnosis', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'diagnosis'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'diagnosis'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'EncounterDiagnosis'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      encounterDiagnosis = new cqm.models.EncounterDiagnosis()
      encounterDiagnosis.condition = new cqm.models.Reference()
      encounterDiagnosis.condition.reference = cqm.models.PrimitiveString.parsePrimitive('Condition/12345')

      encounterDiagnosis.use = DataTypeHelpers.createCodeableConcept('code1', 'system1')
      encounterDiagnosis.rank = cqm.models.PrimitivePositiveInt.parsePrimitive(5555)

      attr.setValue(fhirResource, [ encounterDiagnosis ])

      # clone the resource to make sure setter/getter work with correct data type
      actualValue = attr.getValue(fhirResource.clone())
      expect(actualValue).toBeDefined
      expect(actualValue[0].condition.reference.value).toBe 'Condition/12345'
      expect(actualValue[0].rank.value).toBe 5555
      expect(actualValue[0].use.coding[0].code.value).toBe 'code1'
      expect(actualValue[0].use.coding[0].system.value).toBe 'system1'

    it 'should support Encounter.length', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'length'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'length'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Duration'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Duration()
      valueToSet.unit = cqm.models.PrimitiveString.parsePrimitive('ml')
      valueToSet.value = cqm.models.PrimitiveDecimal.parsePrimitive(100)
      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.unit.value).toBe 'ml'
      expect(value.value.value).toBe 100

    it 'should support Encounter.status', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attr).toBeDefined
      attr = attrs.find (attr) -> attr.path is 'status'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'status'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = cqm.models.EncounterStatus.parsePrimitive('a code')
      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.value).toBe 'a code'

    it 'should support Encounter.location', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attr).toBeDefined
      attr = attrs.find (attr) -> attr.path is 'location'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'location'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'EncounterLocation'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      encounterLocation = new cqm.models.EncounterLocation()
      encounterLocation.period = new cqm.models.Period()
      encounterLocation.period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      encounterLocation.period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')

      encounterLocation.location = new cqm.models.Reference()
      encounterLocation.location.reference = cqm.models.PrimitiveString.parsePrimitive('Location/12345')

      attr.setValue(fhirResource, [ encounterLocation ])

      # clone the resource to make sure setter/getter work with correct data type
      actualValue = attr.getValue(fhirResource.clone())
      expect(actualValue).toBeDefined
      expect(actualValue[0].period.start.value).toBe '2020-09-02T13:54:57'
      expect(actualValue[0].period.end.value).toBe '2020-10-02T13:54:57'
      expect(actualValue[0].location.reference.value).toBe 'Location/12345'

    it 'should support Encounter.identifier', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) -> attr.path is 'identifier'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'identifier'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Identifier'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Identifier()
      valueToSet.use = cqm.models.IdentifierUse.parsePrimitive('xyz')
      valueToSet.system = cqm.models.PrimitiveUri.parsePrimitive('someuri')
      valueToSet.value = cqm.models.PrimitiveString.parsePrimitive('abs53dr585tm')
      valueToSet.assigner = cqm.models.Reference.parse({display: 'SB'})
      attr.setValue(fhirResource, [valueToSet])

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value[0].use.value).toBe 'xyz'
      expect(value[0].system.value).toBe 'someuri'
      expect(value[0].value.value).toBe 'abs53dr585tm'
      expect(value[0].assigner.display.value).toBe 'SB'

      # remove value test
      attr.setValue(fhirResource, undefined)
      value = attr.getValue(fhirResource)
      expect(value).toBeUndefined()

    it 'should support Encounter.hospitalization.dischargeDisposition', ->
      DataCriteriaAsserts.assertCodeableConcept('Encounter', 'hospitalization.dischargeDisposition')

    it 'should support Encounter.hospitalization.admitSource', ->
      DataCriteriaAsserts.assertCodeableConcept('Encounter', 'hospitalization.admitSource')
