describe 'DataCriteriaHelpers', ->

  describe 'Medication Administration attributes', ->

    it 'doesnt support MedicationAdministration primary code path', ->
      dataElement = new cqm.models.DataElement()
      dataElement.fhir_resource = new cqm.models['MedicationAdministration']()
      expect(DataCriteriaHelpers.isPrimaryCodePathSupported(dataElement)).toBe(false)

    it 'should support MedicationAdministration.dosage.route', ->
      DataCriteriaAsserts.assertCodeableConcept('MedicationAdministration', 'dosage.route')

    it 'should support MedicationAdministration.reasonCode', ->
      DataCriteriaAsserts.assertCodeableConcept('MedicationAdministration', 'reasonCode')

    it 'should support MedicationAdministration.effective as period', ->
      DataCriteriaAsserts.assertPeriod('MedicationAdministration', 'effective')

    it 'should support MedicationAdministration.effective as dateTime', ->
      DataCriteriaAsserts.assertDateTime('MedicationAdministration', 'effective')

    it 'should support MedicationAdministration.status', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationAdministration']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'status'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'status'
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
      DataCriteriaAsserts.assertCodeableConcept('MedicationAdministration', 'statusReason' )

    it 'should support MedicationAdministration.medication', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationAdministration']
      attr = attrs.find (attr) -> attr.path is 'medication'
      expect(attr.path).toEqual 'medication'
      expect(attr.types).toEqual [ 'CodeableConcept', 'Reference' ]

      fhirResource = new cqm.models['MedicationAdministration']()
      codeableConcept = DataTypeHelpers.createCodeableConcept('code1', 'system1')
      attr.setValue(fhirResource, codeableConcept)
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.coding[0].code.value).toBe 'code1'
      expect(value.coding[0].system.value).toBe 'system1'

      #   Reference
      ref = cqm.models.Reference.parse({"reference": "random-reference"})
      attr.setValue(fhirResource, ref)
      value = attr.getValue(fhirResource.clone())

      expect(value.reference.value).toEqual 'random-reference'