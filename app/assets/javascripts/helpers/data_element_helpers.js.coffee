###*
# Contains helpers related data element codes and primaryCodePath
###
@DataElementHelpers = class DataElementHelpers

  @getPrimaryCodePath: (dataElement) ->
    resourceType = dataElement.fhir_resource?.resourceType
    primaryCodePath = @DATA_ELEMENT_PRIMARY_CODE_PATH[resourceType]
    return primaryCodePath

  @getPrimaryCodes: (dataElement) ->
    primaryCodePath = @getPrimaryCodePath dataElement
    fhirResource = dataElement.fhir_resource;
# if primaryCodePath.path is undefined then data element does not support codes
    return undefined unless primaryCodePath.path?
    primaryCode = fhirResource[primaryCodePath.path]
    return [] unless primaryCode
    codeableConcept = if primaryCodePath.array then primaryCode[0] else primaryCode
    return codeableConcept.coding || []

  @setPrimaryCodes: (dataElement, codes) ->
    primaryCodePath = @getPrimaryCodePath dataElement
    fhirResource = dataElement.fhir_resource;
# if primaryCodePath.path is undefined then data element does not support codes
    return unless primaryCodePath.path?
    codeableConcept = new cqm.models.CodeableConcept()
    codeableConcept.coding = codes
    primaryCode = if primaryCodePath.array then [ codeableConcept ] else codeableConcept
    fhirResource[primaryCodePath.path] = primaryCode

  @DATA_ELEMENT_PRIMARY_CODE_PATH:
      AdverseEvent:                 { path: 'event', array: false }
      AllergyIntolerance:           { path: 'code', array: false }
      Condition:                    { path: 'code', array: false }
      FamilyMemberHistory:          { path: 'relationship', array: false }
      Procedure:                    { path: 'code', array: false }
      Coverage:                     { path: 'type', array: false }
      BodyStructure:                { path: 'location', array: false }
      DiagnosticReport:             { path: 'code', array: false }
      ImagingStudy:                 { path: 'procedureCode', array: true }
      Observation:                  { path: 'code', array: false }
      Specimen:                     { path: 'type', array: false }
      CarePlan:                     { path: 'category', array: true }
      CareTeam:                     { path: 'category', array: true }
      Goal:                         { path: 'category', array: true }
      NutritionOrder:               { path: 'foodPreferenceModifier', array: true }
      ServiceRequest:               { path: 'code', array: false }
      Claim:                        { path: 'type', array: false }
      Communication:                { path: 'category', array: true }
      CommunicationRequest:         { path: 'category', array: true }
      DeviceRequest:                { path: 'code', array: false }
      DeviceUseStatement:           { path: 'reasonCode', array: true }
      Location:                     { path: 'type', array: true }
      Device:                       { path: 'type', array: false }
      Substance:                    { path: 'code', array: false }
      Encounter:                    { path: 'type', array: true }
      Flag:                         { path: 'code', array: false }
      Immunization:                 { path: 'vaccineCode', array: false }
      ImmunizationEvaluation:       { path: 'targetDisease', array: false }
  # Not supported
      ImmunizationRecommendation:   { path: null, array: false }
      Medication:                   { path: 'code', array: false }
      MedicationAdministration:     { path: 'medication', array: false }
      MedicationDispense:           { path: 'medication', array: false }
      MedicationRequest:            { path: 'medication', array: false }
      MedicationStatement:          { path: 'medication', array: false }

      Patient:                      { path: 'maritalStatus', array: false }
      Practitioner:                 { path: 'communication', array: true }
      PractitionerRole:             { path: 'code', array: true }
      RelatedPerson:                { path: 'relationship', array: true }

      Task:                         { path: 'code', array: false }

