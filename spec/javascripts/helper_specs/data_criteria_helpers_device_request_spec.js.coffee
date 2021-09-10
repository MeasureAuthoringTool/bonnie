describe 'DataCriteriaHelpers', ->

  describe 'DeviceRequest', ->

    it 'should support DeviceRequest.code', ->
      DataCriteriaAsserts.assertCodeableConcept('DeviceRequest', 'code')
      DataCriteriaAsserts.assertReference('DeviceRequest', 'code')
