@ReferenceBindings = class ReferenceBindings
  @REFERENCE_BINDINGS: {
    "Extension": {
      "value": [
        "EpisodeOfCare"
      ]
    },
    "PlanDefinition": {
      "subject": [
        "Group"
      ]
    },
    "PlanDefinitionGoal": {},
    "PlanDefinitionGoalTarget": {},
    "PlanDefinitionAction": {
      "subject": [
        "Group"
      ]
    },
    "PlanDefinitionActionCondition": {},
    "PlanDefinitionActionRelatedAction": {},
    "PlanDefinitionActionParticipant": {},
    "PlanDefinitionActionDynamicValue": {},
    "ExtensionExtension": {
      "value": [
        "FamilyMemberHistory"
      ]
    },
    "Schedule": {
      "actor": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Device",
        "HealthcareService",
        "Location"
      ]
    },
    "ValueSet": {},
    "ValueSetCompose": {},
    "ValueSetComposeInclude": {},
    "ValueSetComposeIncludeConcept": {},
    "ValueSetComposeIncludeConceptDesignation": {},
    "ValueSetComposeIncludeFilter": {},
    "ValueSetExpansion": {},
    "ValueSetExpansionParameter": {},
    "ValueSetExpansionContains": {},
    "SubstanceAmount": {},
    "SubstanceAmountReferenceRange": {},
    "UsageContext": {
      "value": [
        "PlanDefinition",
        "ResearchStudy",
        "InsurancePlan",
        "HealthcareService",
        "Group",
        "Location",
        "Organization"
      ]
    },
    "Meta": {},
    "ActivityDefinition": {
      "subject": [
        "Group"
      ],
      "location": [
        "Location"
      ],
      "product": [
        "Medication",
        "Substance"
      ],
      "specimenRequirement": [
        "SpecimenDefinition"
      ],
      "observationRequirement": [
        "ObservationDefinition"
      ],
      "observationResultRequirement": [
        "ObservationDefinition"
      ]
    },
    "ActivityDefinitionParticipant": {},
    "ActivityDefinitionDynamicValue": {},
    "Observation": {
      "basedOn": [
        "CarePlan",
        "DeviceRequest",
        "ImmunizationRecommendation",
        "MedicationRequest",
        "NutritionOrder",
        "ServiceRequest"
      ],
      "partOf": [
        "MedicationAdministration",
        "MedicationDispense",
        "MedicationStatement",
        "Procedure",
        "Immunization",
        "ImagingStudy"
      ],
      "subject": [
        "Patient"
      ],
      "focus": [
        "Resource"
      ],
      "encounter": [
        "Encounter"
      ],
      "performer": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam",
        "Patient",
        "RelatedPerson"
      ],
      "specimen": [
        "Specimen"
      ],
      "device": [
        "Device",
        "DeviceMetric"
      ],
      "hasMember": [
        "QuestionnaireResponse",
        "MolecularSequence",
        "vitalsigns"
      ],
      "derivedFrom": [
        "DocumentReference",
        "ImagingStudy",
        "Media",
        "QuestionnaireResponse",
        "MolecularSequence",
        "vitalsigns"
      ]
    },
    "ObservationCategory": {},
    "ObservationCategoryCoding": {},
    "ObservationCode": {},
    "ObservationCodeCoding": {},
    "ObservationReferenceRange": {},
    "ObservationComponent": {},
    "ObservationComponentCode": {},
    "ObservationComponentCodeCoding": {},
    "ObservationComponentValue": {},
    "ObservationValue": {},
    "PaymentReconciliation": {
      "paymentIssuer": [
        "Organization"
      ],
      "request": [
        "Task"
      ],
      "requestor": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "PaymentReconciliationDetail": {
      "request": [
        "Resource"
      ],
      "submitter": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "response": [
        "Resource"
      ],
      "responsible": [
        "PractitionerRole"
      ],
      "payee": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "PaymentReconciliationProcessNote": {},
    "AppointmentResponse": {
      "appointment": [
        "Appointment"
      ],
      "actor": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Device",
        "HealthcareService",
        "Location"
      ]
    },
    "EvidenceVariable": {},
    "EvidenceVariableCharacteristic": {
      "definition": [
        "Group"
      ]
    },
    "Coding": {},
    "Claim": {
      "patient": [
        "Patient"
      ],
      "enterer": [
        "Practitioner",
        "PractitionerRole"
      ],
      "insurer": [
        "Organization"
      ],
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "prescription": [
        "DeviceRequest",
        "MedicationRequest",
        "VisionPrescription"
      ],
      "originalPrescription": [
        "DeviceRequest",
        "MedicationRequest",
        "VisionPrescription"
      ],
      "referral": [
        "ServiceRequest"
      ],
      "facility": [
        "Location"
      ]
    },
    "ClaimRelated": {
      "claim": [
        "Claim"
      ]
    },
    "ClaimPayee": {
      "party": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "RelatedPerson"
      ]
    },
    "ClaimCareTeam": {
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "ClaimSupportingInfo": {
      "value": [
        "Resource"
      ]
    },
    "ClaimDiagnosis": {
      "diagnosis": [
        "Condition"
      ]
    },
    "ClaimProcedure": {
      "procedure": [
        "Procedure"
      ],
      "udi": [
        "Device"
      ]
    },
    "ClaimInsurance": {
      "coverage": [
        "Coverage"
      ],
      "claimResponse": [
        "ClaimResponse"
      ]
    },
    "ClaimAccident": {
      "location": [
        "Location"
      ]
    },
    "ClaimItem": {
      "location": [
        "Location"
      ],
      "udi": [
        "Device"
      ],
      "encounter": [
        "Encounter"
      ]
    },
    "ClaimItemDetail": {
      "udi": [
        "Device"
      ]
    },
    "ClaimItemDetailSubDetail": {
      "udi": [
        "Device"
      ]
    },
    "DocumentManifest": {
      "subject": [
        "Patient",
        "Practitioner",
        "Group",
        "Device"
      ],
      "author": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Device",
        "Patient",
        "RelatedPerson"
      ],
      "recipient": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Organization"
      ],
      "content": [
        "Resource"
      ]
    },
    "DocumentManifestRelated": {
      "ref": [
        "Resource"
      ]
    },
    "StructureDefinition": {},
    "StructureDefinitionMapping": {},
    "StructureDefinitionContext": {},
    "StructureDefinitionSnapshot": {},
    "StructureDefinitionDifferential": {},
    "ObservationDefinition": {
      "validCodedValueSet": [
        "ValueSet"
      ],
      "normalCodedValueSet": [
        "ValueSet"
      ],
      "abnormalCodedValueSet": [
        "ValueSet"
      ],
      "criticalCodedValueSet": [
        "ValueSet"
      ]
    },
    "ObservationDefinitionQuantitativeDetails": {},
    "ObservationDefinitionQualifiedInterval": {},
    "RelatedPerson": {
      "patient": [
        "Patient"
      ]
    },
    "RelatedPersonCommunication": {},
    "CodeSystem": {},
    "CodeSystemFilter": {},
    "CodeSystemProperty": {},
    "CodeSystemConcept": {},
    "CodeSystemConceptDesignation": {},
    "CodeSystemConceptProperty": {},
    "Timing": {},
    "TimingRepeat": {},
    "Medication": {
      "manufacturer": [
        "Organization"
      ]
    },
    "MedicationIngredient": {
      "item": [
        "Substance",
        "Medication"
      ]
    },
    "MedicationBatch": {},
    "Contributor": {},
    "SupplyRequest": {
      "item": [
        "Medication",
        "Substance",
        "Device"
      ],
      "requester": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "RelatedPerson",
        "Device"
      ],
      "supplier": [
        "Organization",
        "HealthcareService"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ],
      "deliverFrom": [
        "Organization",
        "Location"
      ],
      "deliverTo": [
        "Organization",
        "Location",
        "Patient"
      ]
    },
    "SupplyRequestParameter": {},
    "MolecularSequence": {
      "patient": [
        "Patient"
      ],
      "specimen": [
        "Specimen"
      ],
      "device": [
        "Device"
      ],
      "performer": [
        "Organization"
      ],
      "pointer": [
        "MolecularSequence"
      ]
    },
    "MolecularSequenceReferenceSeq": {
      "referenceSeqPointer": [
        "MolecularSequence"
      ]
    },
    "MolecularSequenceVariant": {
      "variantPointer": [
        "Observation"
      ]
    },
    "MolecularSequenceQuality": {},
    "MolecularSequenceQualityRoc": {},
    "MolecularSequenceRepository": {},
    "MolecularSequenceStructureVariant": {},
    "MolecularSequenceStructureVariantOuter": {},
    "MolecularSequenceStructureVariantInner": {},
    "Condition": {
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "recorder": [
        "Practitioner",
        "PractitionerRole",
        "Patient",
        "RelatedPerson"
      ],
      "asserter": [
        "Practitioner",
        "PractitionerRole",
        "Patient",
        "RelatedPerson"
      ]
    },
    "ConditionStage": {
      "assessment": [
        "ClinicalImpression",
        "DiagnosticReport",
        "Observation"
      ]
    },
    "ConditionEvidence": {
      "detail": [
        "Resource"
      ]
    },
    "DomainResource": {},
    "Composition": {
      "subject": [
        "Resource"
      ],
      "encounter": [
        "Encounter"
      ],
      "author": [
        "Practitioner",
        "PractitionerRole",
        "Device",
        "Patient",
        "RelatedPerson",
        "Organization"
      ],
      "custodian": [
        "Organization"
      ]
    },
    "CompositionAttester": {
      "party": [
        "Patient",
        "RelatedPerson",
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "CompositionRelatesTo": {
      "target": [
        "Composition"
      ]
    },
    "CompositionEvent": {
      "detail": [
        "Resource"
      ]
    },
    "CompositionSection": {
      "author": [
        "Practitioner",
        "PractitionerRole",
        "Device",
        "Patient",
        "RelatedPerson",
        "Organization"
      ],
      "focus": [
        "Resource"
      ],
      "entry": [
        "CatalogEntry"
      ]
    },
    "ChargeItemDefinition": {
      "instance": [
        "Medication",
        "Substance",
        "Device"
      ]
    },
    "ChargeItemDefinitionApplicability": {},
    "ChargeItemDefinitionPropertyGroup": {},
    "ChargeItemDefinitionPropertyGroupPriceComponent": {},
    "DiagnosticReport": {
      "basedOn": [
        "CarePlan",
        "ImmunizationRecommendation",
        "MedicationRequest",
        "NutritionOrder",
        "ServiceRequest"
      ],
      "subject": [
        "Patient",
        "Group",
        "Device",
        "Location"
      ],
      "encounter": [
        "Encounter"
      ],
      "performer": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam"
      ],
      "resultsInterpreter": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam"
      ],
      "specimen": [
        "Specimen"
      ],
      "result": [
        "Observation"
      ],
      "imagingStudy": [
        "ImagingStudy"
      ]
    },
    "DiagnosticReportMedia": {
      "link": [
        "Media"
      ]
    },
    "Annotation": {
      "author": [
        "Practitioner",
        "Patient",
        "RelatedPerson",
        "Organization"
      ]
    },
    "DeviceMetric": {
      "source": [
        "Device"
      ],
      "parent": [
        "Device"
      ]
    },
    "DeviceMetricCalibration": {},
    "OperationOutcome": {},
    "OperationOutcomeIssue": {},
    "DocumentReference": {
      "subject": [
        "Patient",
        "Practitioner",
        "Group",
        "Device"
      ],
      "author": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Device",
        "Patient",
        "RelatedPerson"
      ],
      "authenticator": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "custodian": [
        "Organization"
      ]
    },
    "DocumentReferenceRelatesTo": {
      "target": [
        "DocumentReference"
      ]
    },
    "DocumentReferenceContent": {},
    "DocumentReferenceContext": {
      "encounter": [
        "Encounter",
        "EpisodeOfCare"
      ],
      "sourcePatientInfo": [
        "Patient"
      ],
      "related": [
        "Resource"
      ]
    },
    "ClinicalImpression": {
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "assessor": [
        "Practitioner",
        "PractitionerRole"
      ],
      "previous": [
        "ClinicalImpression"
      ],
      "problem": [
        "Condition",
        "AllergyIntolerance"
      ],
      "prognosisReference": [
        "RiskAssessment"
      ],
      "supportingInfo": [
        "Resource"
      ]
    },
    "ClinicalImpressionInvestigation": {
      "item": [
        "Observation",
        "QuestionnaireResponse",
        "FamilyMemberHistory",
        "DiagnosticReport",
        "RiskAssessment",
        "ImagingStudy",
        "Media"
      ]
    },
    "ClinicalImpressionFinding": {
      "itemReference": [
        "Condition",
        "Observation",
        "Media"
      ]
    },
    "EffectEvidenceSynthesis": {
      "population": [
        "EvidenceVariable"
      ],
      "exposure": [
        "EvidenceVariable"
      ],
      "exposureAlternative": [
        "EvidenceVariable"
      ],
      "outcome": [
        "EvidenceVariable"
      ]
    },
    "EffectEvidenceSynthesisSampleSize": {},
    "EffectEvidenceSynthesisResultsByExposure": {
      "riskEvidenceSynthesis": [
        "RiskEvidenceSynthesis"
      ]
    },
    "EffectEvidenceSynthesisEffectEstimate": {},
    "EffectEvidenceSynthesisEffectEstimatePrecisionEstimate": {},
    "EffectEvidenceSynthesisCertainty": {},
    "EffectEvidenceSynthesisCertaintyCertaintySubcomponent": {},
    "ClaimResponse": {
      "patient": [
        "Patient"
      ],
      "insurer": [
        "Organization"
      ],
      "requestor": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "request": [
        "Claim"
      ],
      "communicationRequest": [
        "CommunicationRequest"
      ]
    },
    "ClaimResponseItem": {},
    "ClaimResponseItemAdjudication": {},
    "ClaimResponseItemDetail": {},
    "ClaimResponseItemDetailSubDetail": {},
    "ClaimResponseAddItem": {
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "location": [
        "Location"
      ]
    },
    "ClaimResponseAddItemDetail": {},
    "ClaimResponseAddItemDetailSubDetail": {},
    "ClaimResponseTotal": {},
    "ClaimResponsePayment": {},
    "ClaimResponseProcessNote": {},
    "ClaimResponseInsurance": {
      "coverage": [
        "Coverage"
      ],
      "claimResponse": [
        "ClaimResponse"
      ]
    },
    "ClaimResponseError": {},
    "MedicationRequest": {
      "reported": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Organization"
      ],
      "medication": [
        "Medication"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "supportingInformation": [
        "Resource"
      ],
      "requester": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "RelatedPerson",
        "Device"
      ],
      "performer": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "Device",
        "RelatedPerson",
        "CareTeam"
      ],
      "recorder": [
        "Practitioner",
        "PractitionerRole"
      ],
      "reasonReference": [
        "Condition",
        "Observation"
      ],
      "basedOn": [
        "CarePlan",
        "MedicationRequest",
        "ServiceRequest",
        "ImmunizationRecommendation"
      ],
      "insurance": [
        "Coverage",
        "ClaimResponse"
      ],
      "priorPrescription": [
        "MedicationRequest"
      ],
      "detectedIssue": [
        "DetectedIssue"
      ],
      "eventHistory": [
        "Provenance"
      ]
    },
    "MedicationRequestDispenseRequest": {
      "performer": [
        "Organization"
      ]
    },
    "MedicationRequestDispenseRequestInitialFill": {},
    "MedicationRequestSubstitution": {},
    "MedicinalProductIndication": {
      "subject": [
        "MedicinalProduct",
        "Medication"
      ],
      "undesirableEffect": [
        "MedicinalProductUndesirableEffect"
      ]
    },
    "MedicinalProductIndicationOtherTherapy": {
      "medication": [
        "MedicinalProduct",
        "Medication",
        "Substance",
        "SubstanceSpecification"
      ]
    },
    "TerminologyCapabilities": {},
    "TerminologyCapabilitiesSoftware": {},
    "TerminologyCapabilitiesImplementation": {},
    "TerminologyCapabilitiesCodeSystem": {},
    "TerminologyCapabilitiesCodeSystemVersion": {},
    "TerminologyCapabilitiesCodeSystemVersionFilter": {},
    "TerminologyCapabilitiesExpansion": {},
    "TerminologyCapabilitiesExpansionParameter": {},
    "TerminologyCapabilitiesValidateCode": {},
    "TerminologyCapabilitiesTranslation": {},
    "TerminologyCapabilitiesClosure": {},
    "MedicationKnowledge": {
      "manufacturer": [
        "Organization"
      ],
      "associatedMedication": [
        "Medication"
      ],
      "contraindication": [
        "DetectedIssue"
      ]
    },
    "MedicationKnowledgeRelatedMedicationKnowledge": {
      "reference": [
        "MedicationKnowledge"
      ]
    },
    "MedicationKnowledgeMonograph": {
      "source": [
        "DocumentReference",
        "Media"
      ]
    },
    "MedicationKnowledgeIngredient": {
      "item": [
        "Substance"
      ]
    },
    "MedicationKnowledgeCost": {},
    "MedicationKnowledgeMonitoringProgram": {},
    "MedicationKnowledgeAdministrationGuidelines": {
      "indication": [
        "ObservationDefinition"
      ]
    },
    "MedicationKnowledgeAdministrationGuidelinesDosage": {},
    "MedicationKnowledgeAdministrationGuidelinesPatientCharacteristics": {},
    "MedicationKnowledgeMedicineClassification": {},
    "MedicationKnowledgePackaging": {},
    "MedicationKnowledgeDrugCharacteristic": {},
    "MedicationKnowledgeRegulatory": {
      "regulatoryAuthority": [
        "Organization"
      ]
    },
    "MedicationKnowledgeRegulatorySubstitution": {},
    "MedicationKnowledgeRegulatorySchedule": {},
    "MedicationKnowledgeRegulatoryMaxDispense": {},
    "MedicationKnowledgeKinetics": {},
    "ProductShelfLife": {},
    "Period": {},
    "DataRequirement": {
      "subject": [
        "Group"
      ]
    },
    "DataRequirementCodeFilter": {},
    "DataRequirementDateFilter": {},
    "DataRequirementSort": {},
    "Linkage": {
      "author": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "LinkageItem": {
      "resource": [
        "Resource"
      ]
    },
    "Address": {},
    "Location": {
      "managingOrganization": [
        "Organization"
      ],
      "partOf": [
        "Location"
      ],
      "endpoint": [
        "Endpoint"
      ]
    },
    "LocationPosition": {},
    "LocationHoursOfOperation": {},
    "GuidanceResponse": {
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "performer": [
        "Device"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ],
      "evaluationMessage": [
        "OperationOutcome"
      ],
      "outputParameters": [
        "Parameters"
      ],
      "result": [
        "CarePlan",
        "RequestGroup"
      ]
    },
    "Library": {
      "subject": [
        "Group"
      ]
    },
    "ResearchElementDefinition": {
      "subject": [
        "Group"
      ]
    },
    "ResearchElementDefinitionCharacteristic": {},
    "Signature": {
      "who": [
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Patient",
        "Device",
        "Organization"
      ],
      "onBehalfOf": [
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Patient",
        "Device",
        "Organization"
      ]
    },
    "Quantity": {},
    "HealthcareService": {
      "providedBy": [
        "Organization"
      ],
      "location": [
        "Location"
      ],
      "coverageArea": [
        "Location"
      ],
      "endpoint": [
        "Endpoint"
      ]
    },
    "HealthcareServiceEligibility": {},
    "HealthcareServiceAvailableTime": {},
    "HealthcareServiceNotAvailable": {},
    "SubstanceReferenceInformation": {},
    "SubstanceReferenceInformationGene": {
      "source": [
        "DocumentReference"
      ]
    },
    "SubstanceReferenceInformationGeneElement": {
      "source": [
        "DocumentReference"
      ]
    },
    "SubstanceReferenceInformationClassification": {
      "source": [
        "DocumentReference"
      ]
    },
    "SubstanceReferenceInformationTarget": {
      "source": [
        "DocumentReference"
      ]
    },
    "ConceptMap": {},
    "ConceptMapGroup": {},
    "ConceptMapGroupElement": {},
    "ConceptMapGroupElementTarget": {},
    "ConceptMapGroupElementTargetDependsOn": {},
    "ConceptMapGroupUnmapped": {},
    "BackboneElement": {},
    "Attachment": {},
    "InsurancePlan": {
      "ownedBy": [
        "Organization"
      ],
      "administeredBy": [
        "Organization"
      ],
      "coverageArea": [
        "Location"
      ],
      "endpoint": [
        "Endpoint"
      ],
      "network": [
        "Organization"
      ]
    },
    "InsurancePlanContact": {},
    "InsurancePlanCoverage": {
      "network": [
        "Organization"
      ]
    },
    "InsurancePlanCoverageBenefit": {},
    "InsurancePlanCoverageBenefitLimit": {},
    "InsurancePlanPlan": {
      "coverageArea": [
        "Location"
      ],
      "network": [
        "Organization"
      ]
    },
    "InsurancePlanPlanGeneralCost": {},
    "InsurancePlanPlanSpecificCost": {},
    "InsurancePlanPlanSpecificCostBenefit": {},
    "InsurancePlanPlanSpecificCostBenefitCost": {},
    "ElementDefinition": {},
    "ElementDefinitionSlicing": {},
    "ElementDefinitionSlicingDiscriminator": {},
    "ElementDefinitionBase": {},
    "ElementDefinitionType": {},
    "ElementDefinitionExample": {},
    "ElementDefinitionConstraint": {},
    "ElementDefinitionBinding": {},
    "ElementDefinitionMapping": {},
    "Measure": {
      "subject": [
        "Group"
      ]
    },
    "MeasureGroup": {},
    "MeasureGroupPopulation": {},
    "MeasureGroupStratifier": {},
    "MeasureGroupStratifierComponent": {},
    "MeasureSupplementalData": {},
    "CodeableConcept": {},
    "Substance": {},
    "SubstanceInstance": {},
    "SubstanceIngredient": {
      "substance": [
        "Substance"
      ]
    },
    "Distance": {},
    "BodyStructure": {
      "patient": [
        "Patient"
      ]
    },
    "Invoice": {
      "subject": [
        "Patient",
        "Group"
      ],
      "recipient": [
        "Organization",
        "Patient",
        "RelatedPerson"
      ],
      "issuer": [
        "Organization"
      ],
      "account": [
        "Account"
      ]
    },
    "InvoiceParticipant": {
      "actor": [
        "Practitioner",
        "Organization",
        "Patient",
        "PractitionerRole",
        "Device",
        "RelatedPerson"
      ]
    },
    "InvoiceLineItem": {
      "chargeItem": [
        "ChargeItem"
      ]
    },
    "InvoiceLineItemPriceComponent": {},
    "VerificationResult": {
      "target": [
        "Resource"
      ]
    },
    "VerificationResultPrimarySource": {
      "who": [
        "Organization",
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "VerificationResultAttestation": {
      "who": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "onBehalfOf": [
        "Organization",
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "VerificationResultValidator": {
      "organization": [
        "Organization"
      ]
    },
    "Ratio": {},
    "Encounter": {
      "subject": [
        "Patient",
        "Group"
      ],
      "episodeOfCare": [
        "EpisodeOfCare"
      ],
      "basedOn": [
        "ServiceRequest"
      ],
      "appointment": [
        "Appointment"
      ],
      "reasonReference": [
        "Condition",
        "Procedure",
        "Observation",
        "ImmunizationRecommendation"
      ],
      "account": [
        "Account"
      ],
      "serviceProvider": [
        "Organization"
      ],
      "partOf": [
        "Encounter"
      ]
    },
    "EncounterStatusHistory": {},
    "EncounterClassHistory": {},
    "EncounterParticipant": {
      "individual": [
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ]
    },
    "EncounterDiagnosis": {
      "condition": [
        "Condition",
        "Procedure"
      ]
    },
    "EncounterHospitalization": {
      "origin": [
        "Location",
        "Organization"
      ],
      "destination": [
        "Location",
        "Organization"
      ]
    },
    "EncounterLocation": {
      "location": [
        "Location"
      ]
    },
    "Account": {
      "subject": [
        "Patient",
        "Device",
        "Practitioner",
        "PractitionerRole",
        "Location",
        "HealthcareService",
        "Organization"
      ],
      "owner": [
        "Organization"
      ],
      "partOf": [
        "Account"
      ]
    },
    "AccountCoverage": {
      "coverage": [
        "Coverage"
      ]
    },
    "AccountGuarantor": {
      "party": [
        "Patient",
        "RelatedPerson",
        "Organization"
      ]
    },
    "Flag": {
      "subject": [
        "Patient",
        "Location",
        "Group",
        "Organization",
        "Practitioner",
        "PlanDefinition",
        "Medication",
        "Procedure"
      ],
      "encounter": [
        "Encounter"
      ],
      "author": [
        "Device",
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "EpisodeOfCare": {
      "patient": [
        "Patient"
      ],
      "managingOrganization": [
        "Organization"
      ],
      "referralRequest": [
        "ServiceRequest"
      ],
      "careManager": [
        "Practitioner",
        "PractitionerRole"
      ],
      "team": [
        "CareTeam"
      ],
      "account": [
        "Account"
      ]
    },
    "EpisodeOfCareStatusHistory": {},
    "EpisodeOfCareDiagnosis": {
      "condition": [
        "Condition"
      ]
    },
    "MessageDefinition": {},
    "MessageDefinitionFocus": {},
    "MessageDefinitionAllowedResponse": {},
    "CapabilityStatement": {},
    "CapabilityStatementSoftware": {},
    "CapabilityStatementImplementation": {
      "custodian": [
        "Organization"
      ]
    },
    "CapabilityStatementRest": {},
    "CapabilityStatementRestSecurity": {},
    "CapabilityStatementRestResource": {},
    "CapabilityStatementRestResourceInteraction": {},
    "CapabilityStatementRestResourceSearchParam": {},
    "CapabilityStatementRestResourceOperation": {},
    "CapabilityStatementRestInteraction": {},
    "CapabilityStatementMessaging": {},
    "CapabilityStatementMessagingEndpoint": {},
    "CapabilityStatementMessagingSupportedMessage": {},
    "CapabilityStatementDocument": {},
    "Parameters": {},
    "ParametersParameter": {},
    "ExampleScenario": {},
    "ExampleScenarioActor": {},
    "ExampleScenarioInstance": {},
    "ExampleScenarioInstanceVersion": {},
    "ExampleScenarioInstanceContainedInstance": {},
    "ExampleScenarioProcess": {},
    "ExampleScenarioProcessStep": {},
    "ExampleScenarioProcessStepOperation": {},
    "ExampleScenarioProcessStepAlternative": {},
    "ContactDetail": {},
    "Contract": {
      "instantiatesCanonical": [
        "Contract"
      ],
      "subject": [
        "Resource"
      ],
      "authority": [
        "Organization"
      ],
      "domain": [
        "Location"
      ],
      "site": [
        "Location"
      ],
      "author": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "topic": [
        "Resource"
      ],
      "supportingInfo": [
        "Resource"
      ],
      "relevantHistory": [
        "Provenance"
      ],
      "legallyBinding": [
        "Composition",
        "DocumentReference",
        "QuestionnaireResponse",
        "Contract"
      ]
    },
    "ContractContentDefinition": {
      "publisher": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "ContractTerm": {
      "topic": [
        "Resource"
      ]
    },
    "ContractTermSecurityLabel": {},
    "ContractTermOffer": {
      "topic": [
        "Resource"
      ]
    },
    "ContractTermOfferParty": {
      "reference": [
        "Patient",
        "RelatedPerson",
        "Practitioner",
        "PractitionerRole",
        "Device",
        "Group",
        "Organization"
      ]
    },
    "ContractTermOfferAnswer": {
      "value": [
        "Resource"
      ]
    },
    "ContractTermAsset": {
      "typeReference": [
        "Resource"
      ]
    },
    "ContractTermAssetContext": {
      "reference": [
        "Resource"
      ]
    },
    "ContractTermAssetValuedItem": {
      "entity": [
        "Resource"
      ],
      "responsible": [
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ],
      "recipient": [
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ]
    },
    "ContractTermAction": {
      "context": [
        "Encounter",
        "EpisodeOfCare"
      ],
      "requester": [
        "Patient",
        "RelatedPerson",
        "Practitioner",
        "PractitionerRole",
        "Device",
        "Group",
        "Organization"
      ],
      "performer": [
        "RelatedPerson",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "CareTeam",
        "Device",
        "Substance",
        "Organization",
        "Location"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference",
        "Questionnaire",
        "QuestionnaireResponse"
      ]
    },
    "ContractTermActionSubject": {
      "reference": [
        "Patient",
        "RelatedPerson",
        "Practitioner",
        "PractitionerRole",
        "Device",
        "Group",
        "Organization"
      ]
    },
    "ContractSigner": {
      "party": [
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ]
    },
    "ContractFriendly": {
      "content": [
        "Composition",
        "DocumentReference",
        "QuestionnaireResponse"
      ]
    },
    "ContractLegal": {
      "content": [
        "Composition",
        "DocumentReference",
        "QuestionnaireResponse"
      ]
    },
    "ContractRule": {
      "content": [
        "DocumentReference"
      ]
    },
    "ChargeItem": {
      "partOf": [
        "ChargeItem"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "context": [
        "Encounter",
        "EpisodeOfCare"
      ],
      "performingOrganization": [
        "Organization"
      ],
      "requestingOrganization": [
        "Organization"
      ],
      "costCenter": [
        "Organization"
      ],
      "enterer": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "Device",
        "RelatedPerson"
      ],
      "service": [
        "DiagnosticReport",
        "ImagingStudy",
        "Immunization",
        "MedicationAdministration",
        "MedicationDispense",
        "Observation",
        "Procedure",
        "SupplyDelivery"
      ],
      "product": [
        "Device",
        "Medication",
        "Substance"
      ],
      "account": [
        "Account"
      ],
      "supportingInformation": [
        "Resource"
      ]
    },
    "ChargeItemPerformer": {
      "actor": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam",
        "Patient",
        "Device",
        "RelatedPerson"
      ]
    },
    "TestScript": {
      "profile": [
        "Resource"
      ]
    },
    "TestScriptOrigin": {},
    "TestScriptDestination": {},
    "TestScriptMetadata": {},
    "TestScriptMetadataLink": {},
    "TestScriptMetadataCapability": {},
    "TestScriptFixture": {
      "resource": [
        "Resource"
      ]
    },
    "TestScriptVariable": {},
    "TestScriptSetup": {},
    "TestScriptSetupAction": {},
    "TestScriptSetupActionOperation": {},
    "TestScriptSetupActionOperationRequestHeader": {},
    "TestScriptSetupActionAssert": {},
    "TestScriptTest": {},
    "TestScriptTestAction": {},
    "TestScriptTeardown": {},
    "TestScriptTeardownAction": {},
    "Task": {
      "basedOn": [
        "Resource"
      ],
      "partOf": [
        "Task"
      ],
      "focus": [
        "Resource"
      ],
      "for": [
        "Resource"
      ],
      "encounter": [
        "Encounter"
      ],
      "requester": [
        "Device",
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ],
      "owner": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam",
        "HealthcareService",
        "Patient",
        "Device",
        "RelatedPerson"
      ],
      "location": [
        "Location"
      ],
      "reasonReference": [
        "Resource"
      ],
      "insurance": [
        "Coverage",
        "ClaimResponse"
      ],
      "relevantHistory": [
        "Provenance"
      ]
    },
    "TaskRestriction": {
      "recipient": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Group",
        "Organization"
      ]
    },
    "TaskInput": {},
    "TaskOutput": {},
    "Appointment": {
      "reasonReference": [
        "Condition",
        "Procedure",
        "Observation",
        "ImmunizationRecommendation"
      ],
      "supportingInformation": [
        "Resource"
      ],
      "slot": [
        "Slot"
      ],
      "basedOn": [
        "ServiceRequest"
      ]
    },
    "AppointmentParticipant": {
      "actor": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Device",
        "HealthcareService",
        "Location"
      ]
    },
    "Coverage": {
      "policyHolder": [
        "Patient",
        "RelatedPerson",
        "Organization"
      ],
      "subscriber": [
        "Patient",
        "RelatedPerson"
      ],
      "beneficiary": [
        "Patient"
      ],
      "payor": [
        "Organization",
        "Patient",
        "RelatedPerson"
      ],
      "contract": [
        "Contract"
      ]
    },
    "CoverageClass": {},
    "CoverageCostToBeneficiary": {},
    "CoverageCostToBeneficiaryException": {},
    "SupplyDelivery": {
      "basedOn": [
        "SupplyRequest"
      ],
      "partOf": [
        "SupplyDelivery",
        "Contract"
      ],
      "patient": [
        "Patient"
      ],
      "supplier": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "destination": [
        "Location"
      ],
      "receiver": [
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "SupplyDeliverySuppliedItem": {
      "item": [
        "Medication",
        "Substance",
        "Device"
      ]
    },
    "ImmunizationRecommendation": {
      "patient": [
        "Patient"
      ],
      "authority": [
        "Organization"
      ]
    },
    "ImmunizationRecommendationRecommendation": {
      "supportingImmunization": [
        "Immunization",
        "ImmunizationEvaluation"
      ],
      "supportingPatientInformation": [
        "Resource"
      ]
    },
    "ImmunizationRecommendationRecommendationDateCriterion": {},
    "Evidence": {
      "exposureBackground": [
        "EvidenceVariable"
      ],
      "exposureVariant": [
        "EvidenceVariable"
      ],
      "outcome": [
        "EvidenceVariable"
      ]
    },
    "RiskAssessment": {
      "basedOn": [
        "Resource"
      ],
      "parent": [
        "Resource"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "condition": [
        "Condition"
      ],
      "performer": [
        "Practitioner",
        "PractitionerRole",
        "Device"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ],
      "basis": [
        "Resource"
      ]
    },
    "RiskAssessmentPrediction": {},
    "Identifier": {
      "assigner": [
        "Organization"
      ]
    },
    "Organization": {
      "partOf": [
        "Organization"
      ],
      "endpoint": [
        "Endpoint"
      ]
    },
    "OrganizationContact": {},
    "ImagingStudy": {
      "subject": [
        "Patient",
        "Device",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "basedOn": [
        "CarePlan",
        "ServiceRequest",
        "Appointment",
        "AppointmentResponse",
        "Task"
      ],
      "referrer": [
        "Practitioner",
        "PractitionerRole"
      ],
      "interpreter": [
        "Practitioner",
        "PractitionerRole"
      ],
      "endpoint": [
        "Endpoint"
      ],
      "procedureReference": [
        "Procedure"
      ],
      "location": [
        "Location"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "Media",
        "DiagnosticReport",
        "DocumentReference"
      ]
    },
    "ImagingStudySeries": {
      "endpoint": [
        "Endpoint"
      ],
      "specimen": [
        "Specimen"
      ]
    },
    "ImagingStudySeriesPerformer": {
      "actor": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam",
        "Patient",
        "Device",
        "RelatedPerson"
      ]
    },
    "ImagingStudySeriesInstance": {},
    "AuditEvent": {},
    "AuditEventAgent": {
      "who": [
        "PractitionerRole",
        "Practitioner",
        "Organization",
        "Device",
        "Patient",
        "RelatedPerson"
      ],
      "location": [
        "Location"
      ]
    },
    "AuditEventAgentNetwork": {},
    "AuditEventSource": {
      "observer": [
        "PractitionerRole",
        "Practitioner",
        "Organization",
        "Device",
        "Patient",
        "RelatedPerson"
      ]
    },
    "AuditEventEntity": {
      "what": [
        "Resource"
      ]
    },
    "AuditEventEntityDetail": {},
    "MedicinalProductPharmaceutical": {
      "ingredient": [
        "MedicinalProductIngredient"
      ],
      "device": [
        "DeviceDefinition"
      ]
    },
    "MedicinalProductPharmaceuticalCharacteristics": {},
    "MedicinalProductPharmaceuticalRouteOfAdministration": {},
    "MedicinalProductPharmaceuticalRouteOfAdministrationTargetSpecies": {},
    "MedicinalProductPharmaceuticalRouteOfAdministrationTargetSpeciesWithdrawalPeriod": {},
    "SearchParameter": {},
    "SearchParameterComponent": {},
    "SubstanceSourceMaterial": {},
    "SubstanceSourceMaterialFractionDescription": {},
    "SubstanceSourceMaterialOrganism": {},
    "SubstanceSourceMaterialOrganismAuthor": {},
    "SubstanceSourceMaterialOrganismHybrid": {},
    "SubstanceSourceMaterialOrganismOrganismGeneral": {},
    "SubstanceSourceMaterialPartDescription": {},
    "Person": {
      "managingOrganization": [
        "Organization"
      ]
    },
    "PersonLink": {
      "target": [
        "Patient",
        "Practitioner",
        "RelatedPerson",
        "Person"
      ]
    },
    "Provenance": {
      "target": [
        "Resource"
      ],
      "location": [
        "Location"
      ]
    },
    "ProvenanceAgent": {
      "who": [
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Patient",
        "Device",
        "Organization"
      ],
      "onBehalfOf": [
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Patient",
        "Device",
        "Organization"
      ]
    },
    "ProvenanceEntity": {
      "what": [
        "Resource"
      ]
    },
    "GraphDefinition": {},
    "GraphDefinitionLink": {},
    "GraphDefinitionLinkTarget": {},
    "GraphDefinitionLinkTargetCompartment": {},
    "SubstanceProtein": {},
    "SubstanceProteinSubunit": {},
    "Count": {},
    "ContactPoint": {},
    "ResearchDefinition": {
      "subject": [
        "Group"
      ],
      "population": [
        "ResearchElementDefinition"
      ],
      "exposure": [
        "ResearchElementDefinition"
      ],
      "exposureAlternative": [
        "ResearchElementDefinition"
      ],
      "outcome": [
        "ResearchElementDefinition"
      ]
    },
    "ServiceRequest": {
      "basedOn": [
        "CarePlan",
        "ServiceRequest",
        "MedicationRequest"
      ],
      "replaces": [
        "ServiceRequest"
      ],
      "subject": [
        "Patient",
        "Group",
        "Location",
        "Device"
      ],
      "encounter": [
        "Encounter"
      ],
      "requester": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "RelatedPerson",
        "Device"
      ],
      "performer": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam",
        "HealthcareService",
        "Patient",
        "Device",
        "RelatedPerson"
      ],
      "locationReference": [
        "Location"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ],
      "insurance": [
        "Coverage",
        "ClaimResponse"
      ],
      "supportingInfo": [
        "Resource"
      ],
      "specimen": [
        "Specimen"
      ],
      "relevantHistory": [
        "Provenance"
      ]
    },
    "CommunicationRequest": {
      "basedOn": [
        "Resource"
      ],
      "replaces": [
        "CommunicationRequest"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "about": [
        "Resource"
      ],
      "encounter": [
        "Encounter"
      ],
      "requester": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "RelatedPerson",
        "Device"
      ],
      "recipient": [
        "Device",
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Group",
        "CareTeam",
        "HealthcareService"
      ],
      "sender": [
        "Device",
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "HealthcareService"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ]
    },
    "CommunicationRequestPayload": {
      "content": [
        "Resource"
      ]
    },
    "MedicinalProductContraindication": {
      "subject": [
        "MedicinalProduct",
        "Medication"
      ],
      "therapeuticIndication": [
        "MedicinalProductIndication"
      ]
    },
    "MedicinalProductContraindicationOtherTherapy": {
      "medication": [
        "MedicinalProduct",
        "Medication",
        "Substance",
        "SubstanceSpecification"
      ]
    },
    "EnrollmentRequest": {
      "insurer": [
        "Organization"
      ],
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "candidate": [
        "Patient"
      ],
      "coverage": [
        "Coverage"
      ]
    },
    "ElementDefinitionExtension": {},
    "VisionPrescription": {
      "patient": [
        "Patient"
      ],
      "encounter": [
        "Encounter"
      ],
      "prescriber": [
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "VisionPrescriptionLensSpecification": {},
    "VisionPrescriptionLensSpecificationPrism": {},
    "ProdCharacteristic": {},
    "FamilyMemberHistory": {
      "patient": [
        "Patient"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "AllergyIntolerance",
        "QuestionnaireResponse",
        "DiagnosticReport",
        "DocumentReference"
      ]
    },
    "FamilyMemberHistoryCondition": {},
    "Element": {},
    "MedicinalProductUndesirableEffect": {
      "subject": [
        "MedicinalProduct",
        "Medication"
      ]
    },
    "RiskEvidenceSynthesis": {
      "population": [
        "EvidenceVariable"
      ],
      "exposure": [
        "EvidenceVariable"
      ],
      "outcome": [
        "EvidenceVariable"
      ]
    },
    "RiskEvidenceSynthesisSampleSize": {},
    "RiskEvidenceSynthesisRiskEstimate": {},
    "RiskEvidenceSynthesisRiskEstimatePrecisionEstimate": {},
    "RiskEvidenceSynthesisCertainty": {},
    "RiskEvidenceSynthesisCertaintyCertaintySubcomponent": {},
    "CompartmentDefinition": {},
    "CompartmentDefinitionResource": {},
    "Binary": {
      "securityContext": [
        "Resource"
      ]
    },
    "Questionnaire": {},
    "QuestionnaireItem": {},
    "QuestionnaireItemEnableWhen": {
      "answer": [
        "Resource"
      ]
    },
    "QuestionnaireItemAnswerOption": {
      "value": [
        "Resource"
      ]
    },
    "QuestionnaireItemInitial": {
      "value": [
        "Resource"
      ]
    },
    "Specimen": {
      "subject": [
        "Patient",
        "Group",
        "Device",
        "Substance",
        "Location"
      ],
      "parent": [
        "Specimen"
      ],
      "request": [
        "ServiceRequest"
      ]
    },
    "SpecimenCollection": {
      "collector": [
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "SpecimenProcessing": {
      "additive": [
        "Substance"
      ]
    },
    "SpecimenContainer": {
      "additive": [
        "Substance"
      ]
    },
    "RequestGroup": {
      "basedOn": [
        "Resource"
      ],
      "replaces": [
        "Resource"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "author": [
        "Device",
        "Practitioner",
        "PractitionerRole"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ]
    },
    "RequestGroupAction": {
      "participant": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Device"
      ],
      "resource": [
        "Resource"
      ]
    },
    "RequestGroupActionCondition": {},
    "RequestGroupActionRelatedAction": {},
    "ExplanationOfBenefit": {
      "patient": [
        "Patient"
      ],
      "enterer": [
        "Practitioner",
        "PractitionerRole"
      ],
      "insurer": [
        "Organization"
      ],
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "prescription": [
        "MedicationRequest",
        "VisionPrescription"
      ],
      "originalPrescription": [
        "MedicationRequest"
      ],
      "referral": [
        "ServiceRequest"
      ],
      "facility": [
        "Location"
      ],
      "claim": [
        "Claim"
      ],
      "claimResponse": [
        "ClaimResponse"
      ]
    },
    "ExplanationOfBenefitRelated": {
      "claim": [
        "Claim"
      ]
    },
    "ExplanationOfBenefitPayee": {
      "party": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "RelatedPerson"
      ]
    },
    "ExplanationOfBenefitCareTeam": {
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "ExplanationOfBenefitSupportingInfo": {
      "value": [
        "Resource"
      ]
    },
    "ExplanationOfBenefitDiagnosis": {
      "diagnosis": [
        "Condition"
      ]
    },
    "ExplanationOfBenefitProcedure": {
      "procedure": [
        "Procedure"
      ],
      "udi": [
        "Device"
      ]
    },
    "ExplanationOfBenefitInsurance": {
      "coverage": [
        "Coverage"
      ]
    },
    "ExplanationOfBenefitAccident": {
      "location": [
        "Location"
      ]
    },
    "ExplanationOfBenefitItem": {
      "location": [
        "Location"
      ],
      "udi": [
        "Device"
      ],
      "encounter": [
        "Encounter"
      ]
    },
    "ExplanationOfBenefitItemAdjudication": {},
    "ExplanationOfBenefitItemDetail": {
      "udi": [
        "Device"
      ]
    },
    "ExplanationOfBenefitItemDetailSubDetail": {
      "udi": [
        "Device"
      ]
    },
    "ExplanationOfBenefitAddItem": {
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "location": [
        "Location"
      ]
    },
    "ExplanationOfBenefitAddItemDetail": {},
    "ExplanationOfBenefitAddItemDetailSubDetail": {},
    "ExplanationOfBenefitTotal": {},
    "ExplanationOfBenefitPayment": {},
    "ExplanationOfBenefitProcessNote": {},
    "ExplanationOfBenefitBenefitBalance": {},
    "ExplanationOfBenefitBenefitBalanceFinancial": {},
    "Consent": {
      "patient": [
        "Patient"
      ],
      "performer": [
        "Organization",
        "Patient",
        "Practitioner",
        "RelatedPerson",
        "PractitionerRole"
      ],
      "organization": [
        "Organization"
      ],
      "source": [
        "Consent",
        "DocumentReference",
        "Contract",
        "QuestionnaireResponse"
      ]
    },
    "ConsentPolicy": {},
    "ConsentVerification": {
      "verifiedWith": [
        "Patient",
        "RelatedPerson"
      ]
    },
    "ConsentProvision": {},
    "ConsentProvisionActor": {
      "reference": [
        "Device",
        "Group",
        "CareTeam",
        "Organization",
        "Patient",
        "Practitioner",
        "RelatedPerson",
        "PractitionerRole"
      ]
    },
    "ConsentProvisionData": {
      "reference": [
        "Resource"
      ]
    },
    "MedicinalProduct": {
      "pharmaceuticalProduct": [
        "MedicinalProductPharmaceutical"
      ],
      "packagedMedicinalProduct": [
        "MedicinalProductPackaged"
      ],
      "attachedDocument": [
        "DocumentReference"
      ],
      "masterFile": [
        "DocumentReference"
      ],
      "contact": [
        "Organization",
        "PractitionerRole"
      ],
      "clinicalTrial": [
        "ResearchStudy"
      ]
    },
    "MedicinalProductName": {},
    "MedicinalProductNameNamePart": {},
    "MedicinalProductNameCountryLanguage": {},
    "MedicinalProductManufacturingBusinessOperation": {
      "manufacturer": [
        "Organization"
      ],
      "regulator": [
        "Organization"
      ]
    },
    "MedicinalProductSpecialDesignation": {
      "indication": [
        "MedicinalProductIndication"
      ]
    },
    "NamingSystem": {},
    "NamingSystemUniqueId": {},
    "ResearchStudy": {
      "protocol": [
        "PlanDefinition"
      ],
      "partOf": [
        "ResearchStudy"
      ],
      "enrollment": [
        "Group"
      ],
      "sponsor": [
        "Organization"
      ],
      "principalInvestigator": [
        "Practitioner",
        "PractitionerRole"
      ],
      "site": [
        "Location"
      ]
    },
    "ResearchStudyArm": {},
    "ResearchStudyObjective": {},
    "Dosage": {},
    "DosageDoseAndRate": {},
    "StructureMap": {},
    "StructureMapStructure": {},
    "StructureMapGroup": {},
    "StructureMapGroupInput": {},
    "StructureMapGroupRule": {},
    "StructureMapGroupRuleSource": {},
    "StructureMapGroupRuleTarget": {},
    "StructureMapGroupRuleTargetParameter": {},
    "StructureMapGroupRuleDependent": {},
    "PractitionerRole": {
      "practitioner": [
        "Practitioner"
      ],
      "organization": [
        "Organization"
      ],
      "location": [
        "Location"
      ],
      "healthcareService": [
        "HealthcareService"
      ],
      "endpoint": [
        "Endpoint"
      ]
    },
    "PractitionerRoleAvailableTime": {},
    "PractitionerRoleNotAvailable": {},
    "AdverseEvent": {
      "subject": [
        "Patient",
        "Group",
        "Practitioner",
        "RelatedPerson"
      ],
      "encounter": [
        "Encounter"
      ],
      "resultingCondition": [
        "Condition"
      ],
      "location": [
        "Location"
      ],
      "recorder": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ],
      "contributor": [
        "Practitioner",
        "PractitionerRole",
        "Device"
      ],
      "subjectMedicalHistory": [
        "Condition",
        "Observation",
        "AllergyIntolerance",
        "FamilyMemberHistory",
        "Immunization",
        "Procedure",
        "Media",
        "DocumentReference"
      ],
      "referenceDocument": [
        "DocumentReference"
      ],
      "study": [
        "ResearchStudy"
      ]
    },
    "AdverseEventSuspectEntity": {
      "instance": [
        "Immunization",
        "Procedure",
        "Substance",
        "Medication",
        "MedicationAdministration",
        "MedicationStatement",
        "Device"
      ]
    },
    "AdverseEventSuspectEntityCausality": {
      "author": [
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "TriggerDefinition": {
      "timing": [
        "Schedule"
      ]
    },
    "ResearchSubject": {
      "study": [
        "ResearchStudy"
      ],
      "individual": [
        "Patient"
      ],
      "consent": [
        "Consent"
      ]
    },
    "Money": {},
    "Resource": {},
    "ImplementationGuide": {},
    "ImplementationGuideDependsOn": {},
    "ImplementationGuideGlobal": {},
    "ImplementationGuideDefinition": {},
    "ImplementationGuideDefinitionGrouping": {},
    "ImplementationGuideDefinitionResource": {
      "reference": [
        "Resource"
      ]
    },
    "ImplementationGuideDefinitionPage": {
      "name": [
        "Binary"
      ]
    },
    "ImplementationGuideDefinitionParameter": {},
    "ImplementationGuideDefinitionTemplate": {},
    "ImplementationGuideManifest": {},
    "ImplementationGuideManifestResource": {
      "reference": [
        "Resource"
      ]
    },
    "ImplementationGuideManifestPage": {},
    "MedicinalProductIngredient": {
      "manufacturer": [
        "Organization"
      ]
    },
    "MedicinalProductIngredientSpecifiedSubstance": {},
    "MedicinalProductIngredientSpecifiedSubstanceStrength": {},
    "MedicinalProductIngredientSpecifiedSubstanceStrengthReferenceStrength": {},
    "MedicinalProductIngredientSubstance": {},
    "Group": {
      "managingEntity": [
        "Organization",
        "RelatedPerson",
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "GroupCharacteristic": {},
    "GroupMember": {
      "entity": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "Device",
        "Medication",
        "Substance",
        "Group"
      ]
    },
    "MedicinalProductAuthorization": {
      "subject": [
        "MedicinalProduct",
        "MedicinalProductPackaged"
      ],
      "holder": [
        "Organization"
      ],
      "regulator": [
        "Organization"
      ]
    },
    "MedicinalProductAuthorizationJurisdictionalAuthorization": {},
    "MedicinalProductAuthorizationProcedure": {},
    "Patient": {
      "generalPractitioner": [
        "Organization",
        "Practitioner",
        "PractitionerRole"
      ],
      "managingOrganization": [
        "Organization"
      ]
    },
    "PatientContact": {
      "organization": [
        "Organization"
      ]
    },
    "PatientCommunication": {},
    "PatientLink": {
      "other": [
        "Patient",
        "RelatedPerson"
      ]
    },
    "HumanName": {},
    "EventDefinition": {
      "subject": [
        "Group"
      ]
    },
    "DeviceUseStatement": {
      "basedOn": [
        "ServiceRequest"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "derivedFrom": [
        "ServiceRequest",
        "Procedure",
        "Claim",
        "Observation",
        "QuestionnaireResponse",
        "DocumentReference"
      ],
      "source": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ],
      "device": [
        "Device"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference",
        "Media"
      ]
    },
    "BiologicallyDerivedProduct": {
      "request": [
        "ServiceRequest"
      ],
      "parent": [
        "BiologicallyDerivedProduct"
      ]
    },
    "BiologicallyDerivedProductCollection": {
      "collector": [
        "Practitioner",
        "PractitionerRole"
      ],
      "source": [
        "Patient",
        "Organization"
      ]
    },
    "BiologicallyDerivedProductProcessing": {
      "additive": [
        "Substance"
      ]
    },
    "BiologicallyDerivedProductManipulation": {},
    "BiologicallyDerivedProductStorage": {},
    "MessageHeader": {
      "sender": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "enterer": [
        "Practitioner",
        "PractitionerRole"
      ],
      "author": [
        "Practitioner",
        "PractitionerRole"
      ],
      "responsible": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "focus": [
        "Resource"
      ]
    },
    "MessageHeaderDestination": {
      "target": [
        "Device"
      ],
      "receiver": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "MessageHeaderSource": {},
    "MessageHeaderResponse": {
      "details": [
        "OperationOutcome"
      ]
    },
    "SubstancePolymer": {},
    "SubstancePolymerMonomerSet": {},
    "SubstancePolymerMonomerSetStartingMaterial": {},
    "SubstancePolymerRepeat": {},
    "SubstancePolymerRepeatRepeatUnit": {},
    "SubstancePolymerRepeatRepeatUnitDegreeOfPolymerisation": {},
    "SubstancePolymerRepeatRepeatUnitStructuralRepresentation": {},
    "MedicinalProductPackaged": {
      "subject": [
        "MedicinalProduct"
      ],
      "marketingAuthorization": [
        "MedicinalProductAuthorization"
      ],
      "manufacturer": [
        "Organization"
      ]
    },
    "MedicinalProductPackagedBatchIdentifier": {},
    "MedicinalProductPackagedPackageItem": {
      "device": [
        "DeviceDefinition"
      ],
      "manufacturedItem": [
        "MedicinalProductManufactured"
      ],
      "manufacturer": [
        "Organization"
      ]
    },
    "RelatedArtifact": {},
    "MedicinalProductManufactured": {
      "manufacturer": [
        "Organization"
      ],
      "ingredient": [
        "MedicinalProductIngredient"
      ]
    },
    "SubstanceNucleicAcid": {},
    "SubstanceNucleicAcidSubunit": {},
    "SubstanceNucleicAcidSubunitLinkage": {},
    "SubstanceNucleicAcidSubunitSugar": {},
    "Population": {},
    "Communication": {
      "basedOn": [
        "Resource"
      ],
      "partOf": [
        "Resource"
      ],
      "inResponseTo": [
        "Communication"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "about": [
        "Resource"
      ],
      "encounter": [
        "Encounter"
      ],
      "recipient": [
        "Device",
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Group",
        "CareTeam",
        "HealthcareService"
      ],
      "sender": [
        "Device",
        "Organization",
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "HealthcareService"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ]
    },
    "CommunicationPayload": {
      "content": [
        "Resource"
      ]
    },
    "OperationDefinition": {},
    "OperationDefinitionParameter": {},
    "OperationDefinitionParameterBinding": {},
    "OperationDefinitionParameterReferencedFrom": {},
    "OperationDefinitionOverload": {},
    "DetectedIssue": {
      "patient": [
        "Patient"
      ],
      "author": [
        "Practitioner",
        "PractitionerRole",
        "Device"
      ],
      "implicated": [
        "Resource"
      ]
    },
    "DetectedIssueEvidence": {
      "detail": [
        "Resource"
      ]
    },
    "DetectedIssueMitigation": {
      "author": [
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "Procedure": {
      "basedOn": [
        "CarePlan",
        "ServiceRequest"
      ],
      "partOf": [
        "Procedure",
        "Observation",
        "MedicationAdministration"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "recorder": [
        "Patient",
        "RelatedPerson",
        "Practitioner",
        "PractitionerRole"
      ],
      "asserter": [
        "Patient",
        "RelatedPerson",
        "Practitioner",
        "PractitionerRole"
      ],
      "location": [
        "Location"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "Procedure",
        "DiagnosticReport",
        "DocumentReference"
      ],
      "report": [
        "DiagnosticReport",
        "DocumentReference",
        "Composition"
      ],
      "complicationDetail": [
        "Condition"
      ],
      "usedReference": [
        "Device",
        "Medication",
        "Substance"
      ]
    },
    "ProcedurePerformer": {
      "actor": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "RelatedPerson",
        "Device"
      ],
      "onBehalfOf": [
        "Organization"
      ]
    },
    "ProcedureFocalDevice": {
      "manipulated": [
        "Device"
      ]
    },
    "OrganizationAffiliation": {
      "organization": [
        "Organization"
      ],
      "participatingOrganization": [
        "Organization"
      ],
      "network": [
        "Organization"
      ],
      "location": [
        "Location"
      ],
      "healthcareService": [
        "HealthcareService"
      ],
      "endpoint": [
        "Endpoint"
      ]
    },
    "MeasureReport": {
      "subject": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "Location",
        "Device",
        "RelatedPerson",
        "Group"
      ],
      "reporter": [
        "Practitioner",
        "PractitionerRole",
        "Location",
        "Organization"
      ],
      "evaluatedResource": [
        "Resource"
      ]
    },
    "MeasureReportGroup": {},
    "MeasureReportGroupPopulation": {
      "subjectResults": [
        "List"
      ]
    },
    "MeasureReportGroupStratifier": {},
    "MeasureReportGroupStratifierStratum": {},
    "MeasureReportGroupStratifierStratumComponent": {},
    "MeasureReportGroupStratifierStratumPopulation": {
      "subjectResults": [
        "List"
      ]
    },
    "MedicationStatement": {
      "basedOn": [
        "MedicationRequest",
        "CarePlan",
        "ServiceRequest"
      ],
      "partOf": [
        "MedicationAdministration",
        "MedicationDispense",
        "MedicationStatement",
        "Procedure",
        "Observation"
      ],
      "medication": [
        "Medication"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "context": [
        "Encounter",
        "EpisodeOfCare"
      ],
      "informationSource": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Organization"
      ],
      "derivedFrom": [
        "Resource"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport"
      ]
    },
    "DeviceDefinition": {
      "manufacturer": [
        "Organization"
      ],
      "owner": [
        "Organization"
      ],
      "parentDevice": [
        "DeviceDefinition"
      ]
    },
    "DeviceDefinitionUdiDeviceIdentifier": {},
    "DeviceDefinitionDeviceName": {},
    "DeviceDefinitionSpecialization": {},
    "DeviceDefinitionCapability": {},
    "DeviceDefinitionProperty": {},
    "DeviceDefinitionMaterial": {},
    "CatalogEntry": {
      "referencedItem": [
        "Medication",
        "Device",
        "Organization",
        "Practitioner",
        "PractitionerRole",
        "HealthcareService",
        "ActivityDefinition",
        "PlanDefinition",
        "SpecimenDefinition",
        "ObservationDefinition",
        "Binary"
      ]
    },
    "CatalogEntryRelatedEntry": {
      "item": [
        "CatalogEntry"
      ]
    },
    "Slot": {
      "schedule": [
        "Schedule"
      ]
    },
    "CoverageEligibilityRequest": {
      "patient": [
        "Patient"
      ],
      "enterer": [
        "Practitioner",
        "PractitionerRole"
      ],
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "insurer": [
        "Organization"
      ],
      "facility": [
        "Location"
      ]
    },
    "CoverageEligibilityRequestSupportingInfo": {
      "information": [
        "Resource"
      ]
    },
    "CoverageEligibilityRequestInsurance": {
      "coverage": [
        "Coverage"
      ]
    },
    "CoverageEligibilityRequestItem": {
      "provider": [
        "Practitioner",
        "PractitionerRole"
      ],
      "facility": [
        "Location",
        "Organization"
      ],
      "detail": [
        "Resource"
      ]
    },
    "CoverageEligibilityRequestItemDiagnosis": {
      "diagnosis": [
        "Condition"
      ]
    },
    "MedicinalProductInteraction": {
      "subject": [
        "MedicinalProduct",
        "Medication",
        "Substance"
      ]
    },
    "MedicinalProductInteractionInteractant": {
      "item": [
        "MedicinalProduct",
        "Medication",
        "Substance",
        "ObservationDefinition"
      ]
    },
    "List": {
      "subject": [
        "Patient",
        "Group",
        "Device",
        "Location"
      ],
      "encounter": [
        "Encounter"
      ],
      "source": [
        "Practitioner",
        "PractitionerRole",
        "Patient",
        "Device"
      ]
    },
    "ListEntry": {
      "item": [
        "Resource"
      ]
    },
    "Subscription": {},
    "SubscriptionChannel": {},
    "ExtensionExtensionExtension": {},
    "Duration": {},
    "Age": {},
    "SampledData": {},
    "EnrollmentResponse": {
      "request": [
        "EnrollmentRequest"
      ],
      "organization": [
        "Organization"
      ],
      "requestProvider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "Practitioner": {},
    "PractitionerQualification": {
      "issuer": [
        "Organization"
      ]
    },
    "TestReport": {
      "testScript": [
        "TestScript"
      ]
    },
    "TestReportParticipant": {},
    "TestReportSetup": {},
    "TestReportSetupAction": {},
    "TestReportSetupActionOperation": {},
    "TestReportSetupActionAssert": {},
    "TestReportTest": {},
    "TestReportTestAction": {},
    "TestReportTeardown": {},
    "TestReportTeardownAction": {},
    "Device": {
      "definition": [
        "DeviceDefinition"
      ],
      "patient": [
        "Patient"
      ],
      "owner": [
        "Organization"
      ],
      "location": [
        "Location"
      ],
      "parent": [
        "Device"
      ]
    },
    "DeviceUdiCarrier": {},
    "DeviceDeviceName": {},
    "DeviceSpecialization": {},
    "DeviceVersion": {},
    "DeviceProperty": {},
    "Bundle": {},
    "BundleLink": {},
    "BundleEntry": {},
    "BundleEntrySearch": {},
    "BundleEntryRequest": {},
    "BundleEntryResponse": {},
    "MedicationAdministration": {
      "partOf": [
        "MedicationAdministration",
        "Procedure"
      ],
      "medication": [
        "Medication"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "context": [
        "Encounter",
        "EpisodeOfCare"
      ],
      "supportingInformation": [
        "Resource"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport"
      ],
      "request": [
        "MedicationRequest"
      ],
      "device": [
        "Device"
      ],
      "eventHistory": [
        "Provenance"
      ]
    },
    "MedicationAdministrationPerformer": {
      "actor": [
        "Practitioner",
        "PractitionerRole",
        "Patient",
        "RelatedPerson",
        "Device"
      ]
    },
    "MedicationAdministrationDosage": {},
    "Reference": {},
    "NutritionOrder": {
      "patient": [
        "Patient"
      ],
      "encounter": [
        "Encounter"
      ],
      "orderer": [
        "Practitioner",
        "PractitionerRole"
      ],
      "allergyIntolerance": [
        "AllergyIntolerance"
      ]
    },
    "NutritionOrderOralDiet": {},
    "NutritionOrderOralDietNutrient": {},
    "NutritionOrderOralDietTexture": {},
    "NutritionOrderSupplement": {},
    "NutritionOrderEnteralFormula": {},
    "NutritionOrderEnteralFormulaAdministration": {},
    "Range": {},
    "Immunization": {
      "patient": [
        "Patient"
      ],
      "encounter": [
        "Encounter"
      ],
      "location": [
        "Location"
      ],
      "manufacturer": [
        "Organization"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport"
      ]
    },
    "ImmunizationPerformer": {
      "actor": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ]
    },
    "ImmunizationEducation": {},
    "ImmunizationReaction": {
      "detail": [
        "Observation"
      ]
    },
    "ImmunizationProtocolApplied": {
      "authority": [
        "Organization"
      ]
    },
    "SpecimenDefinition": {},
    "SpecimenDefinitionTypeTested": {},
    "SpecimenDefinitionTypeTestedContainer": {},
    "SpecimenDefinitionTypeTestedContainerAdditive": {
      "additive": [
        "Substance"
      ]
    },
    "SpecimenDefinitionTypeTestedHandling": {},
    "Narrative": {},
    "Endpoint": {
      "managingOrganization": [
        "Organization"
      ]
    },
    "Goal": {
      "subject": [
        "Patient",
        "Group",
        "Organization"
      ],
      "expressedBy": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ],
      "addresses": [
        "Condition",
        "Observation",
        "MedicationStatement",
        "NutritionOrder",
        "ServiceRequest",
        "RiskAssessment"
      ],
      "outcomeReference": [
        "Observation"
      ]
    },
    "GoalTarget": {},
    "Expression": {},
    "AllergyIntolerance": {
      "patient": [
        "Patient"
      ],
      "encounter": [
        "Encounter"
      ],
      "recorder": [
        "Practitioner",
        "PractitionerRole",
        "Patient",
        "RelatedPerson"
      ],
      "asserter": [
        "Patient",
        "RelatedPerson",
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "AllergyIntoleranceReaction": {},
    "ParameterDefinition": {},
    "ImmunizationEvaluation": {
      "patient": [
        "Patient"
      ],
      "authority": [
        "Organization"
      ],
      "immunizationEvent": [
        "Immunization"
      ]
    },
    "DeviceRequest": {
      "basedOn": [
        "Resource"
      ],
      "priorRequest": [
        "Resource"
      ],
      "code": [
        "Device"
      ],
      "subject": [
        "Patient",
        "Group",
        "Location",
        "Device"
      ],
      "encounter": [
        "Encounter"
      ],
      "requester": [
        "Device",
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "performer": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam",
        "HealthcareService",
        "Patient",
        "Device",
        "RelatedPerson"
      ],
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ],
      "insurance": [
        "Coverage",
        "ClaimResponse"
      ],
      "supportingInfo": [
        "Resource"
      ],
      "relevantHistory": [
        "Provenance"
      ]
    },
    "DeviceRequestParameter": {},
    "CoverageEligibilityResponse": {
      "patient": [
        "Patient"
      ],
      "requestor": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "request": [
        "CoverageEligibilityRequest"
      ],
      "insurer": [
        "Organization"
      ]
    },
    "CoverageEligibilityResponseInsurance": {
      "coverage": [
        "Coverage"
      ]
    },
    "CoverageEligibilityResponseInsuranceItem": {
      "provider": [
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "CoverageEligibilityResponseInsuranceItemBenefit": {},
    "CoverageEligibilityResponseError": {},
    "Media": {
      "basedOn": [
        "ServiceRequest",
        "CarePlan"
      ],
      "partOf": [
        "Resource"
      ],
      "subject": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "Group",
        "Device",
        "Specimen",
        "Location"
      ],
      "encounter": [
        "Encounter"
      ],
      "operator": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "CareTeam",
        "Patient",
        "Device",
        "RelatedPerson"
      ],
      "device": [
        "Device",
        "DeviceMetric",
        "Device"
      ]
    },
    "MarketingStatus": {},
    "PaymentNotice": {
      "request": [
        "Resource"
      ],
      "response": [
        "Resource"
      ],
      "provider": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "payment": [
        "PaymentReconciliation"
      ],
      "payee": [
        "Practitioner",
        "PractitionerRole",
        "Organization"
      ],
      "recipient": [
        "Organization"
      ]
    },
    "SubstanceSpecification": {
      "source": [
        "DocumentReference"
      ],
      "referenceInformation": [
        "SubstanceReferenceInformation"
      ],
      "nucleicAcid": [
        "SubstanceNucleicAcid"
      ],
      "polymer": [
        "SubstancePolymer"
      ],
      "protein": [
        "SubstanceProtein"
      ],
      "sourceMaterial": [
        "SubstanceSourceMaterial"
      ]
    },
    "SubstanceSpecificationMoiety": {},
    "SubstanceSpecificationProperty": {
      "definingSubstance": [
        "SubstanceSpecification",
        "Substance"
      ]
    },
    "SubstanceSpecificationStructure": {
      "source": [
        "DocumentReference"
      ]
    },
    "SubstanceSpecificationStructureIsotope": {},
    "SubstanceSpecificationStructureIsotopeMolecularWeight": {},
    "SubstanceSpecificationStructureRepresentation": {},
    "SubstanceSpecificationCode": {
      "source": [
        "DocumentReference"
      ]
    },
    "SubstanceSpecificationName": {
      "source": [
        "DocumentReference"
      ]
    },
    "SubstanceSpecificationNameOfficial": {},
    "SubstanceSpecificationRelationship": {
      "substance": [
        "SubstanceSpecification"
      ],
      "source": [
        "DocumentReference"
      ]
    },
    "Basic": {
      "subject": [
        "Resource"
      ],
      "author": [
        "Practitioner",
        "PractitionerRole",
        "Patient",
        "RelatedPerson",
        "Organization"
      ]
    },
    "MedicationDispense": {
      "partOf": [
        "Procedure"
      ],
      "statusReason": [
        "DetectedIssue"
      ],
      "medication": [
        "Medication"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "context": [
        "Encounter",
        "EpisodeOfCare"
      ],
      "supportingInformation": [
        "Resource"
      ],
      "location": [
        "Location"
      ],
      "authorizingPrescription": [
        "MedicationRequest"
      ],
      "destination": [
        "Location"
      ],
      "receiver": [
        "Patient",
        "Practitioner"
      ],
      "detectedIssue": [
        "DetectedIssue"
      ],
      "eventHistory": [
        "Provenance"
      ]
    },
    "MedicationDispensePerformer": {
      "actor": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "Patient",
        "Device",
        "RelatedPerson"
      ]
    },
    "MedicationDispenseSubstitution": {
      "responsibleParty": [
        "Practitioner",
        "PractitionerRole"
      ]
    },
    "QuestionnaireResponse": {
      "basedOn": [
        "CarePlan",
        "ServiceRequest"
      ],
      "partOf": [
        "Observation",
        "Procedure"
      ],
      "subject": [
        "Resource"
      ],
      "encounter": [
        "Encounter"
      ],
      "author": [
        "Device",
        "Practitioner",
        "PractitionerRole",
        "Patient",
        "RelatedPerson",
        "Organization"
      ],
      "source": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson"
      ]
    },
    "QuestionnaireResponseItem": {},
    "QuestionnaireResponseItemAnswer": {
      "value": [
        "Resource"
      ]
    },
    "CareTeam": {
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "reasonReference": [
        "Condition"
      ],
      "managingOrganization": [
        "Organization"
      ]
    },
    "CareTeamParticipant": {
      "member": [
        "Practitioner",
        "PractitionerRole",
        "RelatedPerson",
        "Patient",
        "Organization",
        "CareTeam"
      ],
      "onBehalfOf": [
        "Organization"
      ]
    },
    "CarePlan": {
      "basedOn": [
        "CarePlan"
      ],
      "replaces": [
        "CarePlan"
      ],
      "partOf": [
        "CarePlan"
      ],
      "subject": [
        "Patient",
        "Group"
      ],
      "encounter": [
        "Encounter"
      ],
      "author": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "Device",
        "RelatedPerson",
        "Organization",
        "CareTeam"
      ],
      "contributor": [
        "Patient",
        "Practitioner",
        "PractitionerRole",
        "Device",
        "RelatedPerson",
        "Organization",
        "CareTeam"
      ],
      "careTeam": [
        "CareTeam"
      ],
      "addresses": [
        "Condition"
      ],
      "supportingInfo": [
        "Resource"
      ],
      "goal": [
        "Goal"
      ]
    },
    "CarePlanActivity": {
      "outcomeReference": [
        "Resource"
      ],
      "reference": [
        "Appointment",
        "CommunicationRequest",
        "DeviceRequest",
        "MedicationRequest",
        "NutritionOrder",
        "Task",
        "ServiceRequest",
        "VisionPrescription",
        "RequestGroup"
      ]
    },
    "CarePlanActivityDetail": {
      "reasonReference": [
        "Condition",
        "Observation",
        "DiagnosticReport",
        "DocumentReference"
      ],
      "goal": [
        "Goal"
      ],
      "location": [
        "Location"
      ],
      "performer": [
        "Practitioner",
        "PractitionerRole",
        "Organization",
        "RelatedPerson",
        "Patient",
        "CareTeam",
        "HealthcareService",
        "Device"
      ],
      "product": [
        "Medication",
        "Substance"
      ]
    }
  }
