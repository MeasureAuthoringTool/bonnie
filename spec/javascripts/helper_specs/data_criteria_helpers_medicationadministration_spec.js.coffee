describe 'DataCriteriaHelpers', ->

  describe 'Medication Administration attributes', ->

    it 'doesnt support MedicationAdministration primary code path', ->
      dataElement = new cqm.models.DataElement()
      dataElement.fhir_resource = new cqm.models['MedicationAdministration']()
      expect(DataCriteriaHelpers.isPrimaryCodePathSupported(dataElement)).toBe(false)

    it 'should support MedicationAdministration.dosage.route', ->
      DataCriteriaAsserts.assertCodeableConcept('MedicationAdministration', 'dosage.route', 'dosage.route')

    it 'should support MedicationAdministration.reasonCode', ->
      DataCriteriaAsserts.assertCodeableConcept('MedicationAdministration', 'reasonCode', 'reasonCode')

    it 'should support MedicationAdministration.status', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationAdministration']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'status'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'status'
      expect(attr.title).toBe 'status'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'

      fhirResource = new cqm.models.MedicationAdministration()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = 'a code'
      attr.setValue(fhirResource, valueToSet)
      expect(cqm.models.MedicationAdministrationStatus.isMedicationAdministrationStatus(fhirResource.status)).toBe true

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value).toBe 'a code'

    it 'should support MedicationAdministration.statusReason', ->
      DataCriteriaAsserts.assertCodeableConcept('MedicationAdministration', 'statusReason', 'statusReason')

    it 'should support MedicationAdministration.medication', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationAdministration']
      attr = attrs.find (attr) => attr.path is 'medication'
      expect(attr.path).toEqual 'medication'
      expect(attr.title).toEqual 'medication'
      expect(attr.types).toEqual [ 'CodeableConcept', 'Reference' ]

      fhirResource = new cqm.models['MedicationAdministration']()
      #   CodeableConcept
      coding = new cqm.models.Coding()
      coding.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      coding.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')
      attr.setValue(fhirResource, coding)
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

      #   Reference
      ref = cqm.models.Reference.parse({"reference": "random-reference"})
      attr.setValue(fhirResource, ref)
      value = attr.getValue(fhirResource.clone())

      expect(value.reference.value).toEqual 'random-reference'