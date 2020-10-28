describe 'DataCriteriaHelpers', ->

  describe 'Medication Administration attributes', ->
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