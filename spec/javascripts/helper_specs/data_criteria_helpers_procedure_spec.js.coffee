describe 'DataCriteriaHelpers', ->

  describe 'Procedure attributes', ->
    it 'should support procedure status and performed attributes', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      status = procedureAttrs[0]
      expect(status.path).toEqual 'status'
      expect(status.title).toEqual 'status'
      expect(status.types).toEqual ['Code']
      performed = procedureAttrs[1]
      expect(performed.path).toEqual 'performed'
      expect(performed.title).toEqual 'performed'
      expect(performed.types).toEqual ['DateTime', 'Period']

    it 'should set and get values for procedure status', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      procedureStatus = procedureAttrs[0]
      expect(procedureStatus.path).toEqual 'status'
      procedureResource = new cqm.models.Procedure()
      # when no code is set
      expect(procedureStatus.getValue(procedureResource)).toBeUndefined

      # set the code
      procedureStatus.setValue(procedureResource, 'test code')
      selectedCode = procedureStatus.getValue(procedureResource)
      # Verify after setting code
      expect(selectedCode).toEqual 'test code'

    it 'should get value sets for procedure status', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      procedureStatus = procedureAttrs[0]
      expect(procedureStatus.path).toEqual 'status'
      statusVs = procedureStatus.valueSets()
      expect(statusVs.length).toEqual 1
      expect(statusVs[0].name).toEqual 'EventStatus'
      expect(statusVs[0].compose.include.length).toEqual 1
      expect(statusVs[0].compose.include[0].concept.length).toEqual 8

    it 'should set and get values for performed if Choice type is DateTime', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      performed = procedureAttrs[1]
      expect(performed.path).toEqual 'performed'
      # Create procedure fhir resource & DateTime to set
      procedureResource = new cqm.models.Procedure()
      expect(performed.getValue(procedureResource)).toBeUndefined

      # set performed DateTime to Procedure
      dateTime = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-05T08:00:00')
      performed.setValue(procedureResource, dateTime)
      performedValue = performed.getValue(procedureResource)
      # Verify after setting values
      expect(performedValue.value).toEqual '2020-10-05T08:00:00'

    it 'should set and get values for performed if Choice type is Period', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      performed = procedureAttrs[1]
      expect(performed.path).toEqual 'performed'
      # Create procedure fhir resource & period to set
      procedureResource = new cqm.models.Procedure()
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
      # set performed period to Procedure
      performed.setValue(procedureResource, period)

      performedValue = performed.getValue(procedureResource)
      # Verify after setting values
      expect(performedValue.start.value).toEqual period.start.value
      expect(performedValue.end.value).toEqual period.end.value

    it 'should support Procedure.category', ->
      DataCriteriaAsserts.assertCodeableConcept('Procedure', 'category', 'category')

    it 'should support Procedure.statusReason', ->
      DataCriteriaAsserts.assertCodeableConcept('Procedure', 'statusReason', 'statusReason')

    it 'should support Procedure.usedCode', ->
      DataCriteriaAsserts.assertCodeableConcept('Procedure', 'usedCode', 'usedCode')