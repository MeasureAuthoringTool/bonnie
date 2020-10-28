describe 'DataCriteriaHelpers', ->

  describe 'Immunization Attributes', ->
    it 'should support Immunization.status', ->
      DataCriteriaAsserts.assertCode('Immunization', 'status', 'status', (fhirResource) -> cqm.models.ImmunizationStatus.isImmunizationStatus(fhirResource.status))
