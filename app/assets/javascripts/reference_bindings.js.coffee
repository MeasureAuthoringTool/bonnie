@ReferenceBindings = class ReferenceBindings
  @REFERENCE_BINDINGS: {
    "Extension": {
      "value": {
        "referenceTypes": [
          "EpisodeOfCare"
        ]
      }
    },
    "PlanDefinition": {
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      }
    },
    "PlanDefinitionGoal": {},
    "PlanDefinitionGoalTarget": {},
    "PlanDefinitionAction": {
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      }
    },
    "PlanDefinitionActionCondition": {},
    "PlanDefinitionActionRelatedAction": {},
    "PlanDefinitionActionParticipant": {},
    "PlanDefinitionActionDynamicValue": {},
    "ExtensionExtension": {
      "value": {
        "referenceTypes": [
          "FamilyMemberHistory"
        ]
      }
    },
    "Schedule": {
      "actor": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Device",
          "HealthcareService",
          "Location"
        ]
      }
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
      "value": {
        "referenceTypes": [
          "PlanDefinition",
          "ResearchStudy",
          "InsurancePlan",
          "HealthcareService",
          "Group",
          "Location",
          "Organization"
        ]
      }
    },
    "Meta": {},
    "ActivityDefinition": {
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "product": {
        "referenceTypes": [
          "Medication",
          "Substance"
        ]
      },
      "specimenRequirement": {
        "referenceTypes": [
          "SpecimenDefinition"
        ]
      },
      "observationRequirement": {
        "referenceTypes": [
          "ObservationDefinition"
        ]
      },
      "observationResultRequirement": {
        "referenceTypes": [
          "ObservationDefinition"
        ]
      }
    },
    "ActivityDefinitionParticipant": {},
    "ActivityDefinitionDynamicValue": {},
    "Observation": {
      "basedOn": {
        "referenceTypes": [
          "CarePlan",
          "DeviceRequest",
          "ImmunizationRecommendation",
          "MedicationRequest",
          "NutritionOrder",
          "ServiceRequest"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "MedicationAdministration",
          "MedicationDispense",
          "MedicationStatement",
          "Procedure",
          "Immunization",
          "ImagingStudy"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "focus": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam",
          "Patient",
          "RelatedPerson"
        ]
      },
      "specimen": {
        "referenceTypes": [
          "Specimen"
        ]
      },
      "device": {
        "referenceTypes": [
          "Device",
          "DeviceMetric"
        ]
      },
      "hasMember": {
        "referenceTypes": [
          "QuestionnaireResponse",
          "MolecularSequence",
          "vitalsigns"
        ]
      },
      "derivedFrom": {
        "referenceTypes": [
          "DocumentReference",
          "ImagingStudy",
          "Media",
          "QuestionnaireResponse",
          "MolecularSequence",
          "vitalsigns"
        ]
      }
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
      "paymentIssuer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "request": {
        "referenceTypes": [
          "Task"
        ]
      },
      "requestor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "PaymentReconciliationDetail": {
      "request": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "submitter": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "response": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "responsible": {
        "referenceTypes": [
          "PractitionerRole"
        ]
      },
      "payee": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "PaymentReconciliationProcessNote": {},
    "AppointmentResponse": {
      "appointment": {
        "referenceTypes": [
          "Appointment"
        ]
      },
      "actor": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Device",
          "HealthcareService",
          "Location"
        ]
      }
    },
    "EvidenceVariable": {},
    "EvidenceVariableCharacteristic": {
      "definition": {
        "referenceTypes": [
          "Group"
        ]
      }
    },
    "Coding": {},
    "Claim": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "enterer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "insurer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "prescription": {
        "referenceTypes": [
          "DeviceRequest",
          "MedicationRequest",
          "VisionPrescription"
        ]
      },
      "originalPrescription": {
        "referenceTypes": [
          "DeviceRequest",
          "MedicationRequest",
          "VisionPrescription"
        ]
      },
      "referral": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      },
      "facility": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "ClaimRelated": {
      "claim": {
        "referenceTypes": [
          "Claim"
        ]
      }
    },
    "ClaimPayee": {
      "party": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "RelatedPerson"
        ]
      }
    },
    "ClaimCareTeam": {
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "ClaimSupportingInfo": {
      "value": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ClaimDiagnosis": {
      "diagnosis": {
        "referenceTypes": [
          "Condition"
        ]
      }
    },
    "ClaimProcedure": {
      "procedure": {
        "referenceTypes": [
          "Procedure"
        ]
      },
      "udi": {
        "referenceTypes": [
          "Device"
        ]
      }
    },
    "ClaimInsurance": {
      "coverage": {
        "referenceTypes": [
          "Coverage"
        ]
      },
      "claimResponse": {
        "referenceTypes": [
          "ClaimResponse"
        ]
      }
    },
    "ClaimAccident": {
      "location": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "ClaimItem": {
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "udi": {
        "referenceTypes": [
          "Device"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      }
    },
    "ClaimItemDetail": {
      "udi": {
        "referenceTypes": [
          "Device"
        ]
      }
    },
    "ClaimItemDetailSubDetail": {
      "udi": {
        "referenceTypes": [
          "Device"
        ]
      }
    },
    "DocumentManifest": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "Group",
          "Device"
        ]
      },
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Device",
          "Patient",
          "RelatedPerson"
        ]
      },
      "recipient": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Organization"
        ]
      },
      "content": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "DocumentManifestRelated": {
      "ref": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "StructureDefinition": {},
    "StructureDefinitionMapping": {},
    "StructureDefinitionContext": {},
    "StructureDefinitionSnapshot": {},
    "StructureDefinitionDifferential": {},
    "ObservationDefinition": {
      "validCodedValueSet": {
        "referenceTypes": [
          "ValueSet"
        ]
      },
      "normalCodedValueSet": {
        "referenceTypes": [
          "ValueSet"
        ]
      },
      "abnormalCodedValueSet": {
        "referenceTypes": [
          "ValueSet"
        ]
      },
      "criticalCodedValueSet": {
        "referenceTypes": [
          "ValueSet"
        ]
      }
    },
    "ObservationDefinitionQuantitativeDetails": {},
    "ObservationDefinitionQualifiedInterval": {},
    "RelatedPerson": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      }
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
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "MedicationIngredient": {
      "item": {
        "referenceTypes": [
          "Substance",
          "Medication"
        ]
      }
    },
    "MedicationBatch": {},
    "Contributor": {},
    "SupplyRequest": {
      "item": {
        "referenceTypes": [
          "Medication",
          "Substance",
          "Device"
        ]
      },
      "requester": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "RelatedPerson",
          "Device"
        ]
      },
      "supplier": {
        "referenceTypes": [
          "Organization",
          "HealthcareService"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      },
      "deliverFrom": {
        "referenceTypes": [
          "Organization",
          "Location"
        ]
      },
      "deliverTo": {
        "referenceTypes": [
          "Organization",
          "Location",
          "Patient"
        ]
      }
    },
    "SupplyRequestParameter": {},
    "MolecularSequence": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "specimen": {
        "referenceTypes": [
          "Specimen"
        ]
      },
      "device": {
        "referenceTypes": [
          "Device"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "pointer": {
        "referenceTypes": [
          "MolecularSequence"
        ]
      }
    },
    "MolecularSequenceReferenceSeq": {
      "referenceSeqPointer": {
        "referenceTypes": [
          "MolecularSequence"
        ]
      }
    },
    "MolecularSequenceVariant": {
      "variantPointer": {
        "referenceTypes": [
          "Observation"
        ]
      }
    },
    "MolecularSequenceQuality": {},
    "MolecularSequenceQualityRoc": {},
    "MolecularSequenceRepository": {},
    "MolecularSequenceStructureVariant": {},
    "MolecularSequenceStructureVariantOuter": {},
    "MolecularSequenceStructureVariantInner": {},
    "Condition": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "recorder": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Patient",
          "RelatedPerson"
        ]
      },
      "asserter": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Patient",
          "RelatedPerson"
        ]
      }
    },
    "ConditionStage": {
      "assessment": {
        "referenceTypes": [
          "ClinicalImpression",
          "DiagnosticReport",
          "Observation"
        ]
      }
    },
    "ConditionEvidence": {
      "detail": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "DomainResource": {},
    "Composition": {
      "subject": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Device",
          "Patient",
          "RelatedPerson",
          "Organization"
        ]
      },
      "custodian": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "CompositionAttester": {
      "party": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "CompositionRelatesTo": {
      "target": {
        "referenceTypes": [
          "Composition"
        ]
      }
    },
    "CompositionEvent": {
      "detail": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "CompositionSection": {
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Device",
          "Patient",
          "RelatedPerson",
          "Organization"
        ]
      },
      "focus": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "entry": {
        "referenceTypes": [
          "CatalogEntry"
        ]
      }
    },
    "ChargeItemDefinition": {
      "instance": {
        "referenceTypes": [
          "Medication",
          "Substance",
          "Device"
        ]
      }
    },
    "ChargeItemDefinitionApplicability": {},
    "ChargeItemDefinitionPropertyGroup": {},
    "ChargeItemDefinitionPropertyGroupPriceComponent": {},
    "DiagnosticReport": {
      "basedOn": {
        "referenceTypes": [
          "CarePlan",
          "ImmunizationRecommendation",
          "MedicationRequest",
          "NutritionOrder",
          "ServiceRequest"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group",
          "Device",
          "Location"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam"
        ]
      },
      "resultsInterpreter": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam"
        ]
      },
      "specimen": {
        "referenceTypes": [
          "Specimen"
        ]
      },
      "result": {
        "referenceTypes": [
          "Observation"
        ]
      },
      "imagingStudy": {
        "referenceTypes": [
          "ImagingStudy"
        ]
      }
    },
    "DiagnosticReportMedia": {
      "link": {
        "referenceTypes": [
          "Media"
        ]
      }
    },
    "Annotation": {
      "author": {
        "referenceTypes": [
          "Practitioner",
          "Patient",
          "RelatedPerson",
          "Organization"
        ]
      }
    },
    "DeviceMetric": {
      "source": {
        "referenceTypes": [
          "Device"
        ]
      },
      "parent": {
        "referenceTypes": [
          "Device"
        ]
      }
    },
    "DeviceMetricCalibration": {},
    "OperationOutcome": {},
    "OperationOutcomeIssue": {},
    "DocumentReference": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "Group",
          "Device"
        ]
      },
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Device",
          "Patient",
          "RelatedPerson"
        ]
      },
      "authenticator": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "custodian": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "DocumentReferenceRelatesTo": {
      "target": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "DocumentReferenceContent": {},
    "DocumentReferenceContext": {
      "encounter": {
        "referenceTypes": [
          "Encounter",
          "EpisodeOfCare"
        ]
      },
      "sourcePatientInfo": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "related": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ClinicalImpression": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "assessor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "previous": {
        "referenceTypes": [
          "ClinicalImpression"
        ]
      },
      "problem": {
        "referenceTypes": [
          "Condition",
          "AllergyIntolerance"
        ]
      },
      "prognosisReference": {
        "referenceTypes": [
          "RiskAssessment"
        ]
      },
      "supportingInfo": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ClinicalImpressionInvestigation": {
      "item": {
        "referenceTypes": [
          "Observation",
          "QuestionnaireResponse",
          "FamilyMemberHistory",
          "DiagnosticReport",
          "RiskAssessment",
          "ImagingStudy",
          "Media"
        ]
      }
    },
    "ClinicalImpressionFinding": {
      "itemReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "Media"
        ]
      }
    },
    "EffectEvidenceSynthesis": {
      "population": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      },
      "exposure": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      },
      "exposureAlternative": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      },
      "outcome": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      }
    },
    "EffectEvidenceSynthesisSampleSize": {},
    "EffectEvidenceSynthesisResultsByExposure": {
      "riskEvidenceSynthesis": {
        "referenceTypes": [
          "RiskEvidenceSynthesis"
        ]
      }
    },
    "EffectEvidenceSynthesisEffectEstimate": {},
    "EffectEvidenceSynthesisEffectEstimatePrecisionEstimate": {},
    "EffectEvidenceSynthesisCertainty": {},
    "EffectEvidenceSynthesisCertaintyCertaintySubcomponent": {},
    "ClaimResponse": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "insurer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "requestor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "request": {
        "referenceTypes": [
          "Claim"
        ]
      },
      "communicationRequest": {
        "referenceTypes": [
          "CommunicationRequest"
        ]
      }
    },
    "ClaimResponseItem": {},
    "ClaimResponseItemAdjudication": {},
    "ClaimResponseItemDetail": {},
    "ClaimResponseItemDetailSubDetail": {},
    "ClaimResponseAddItem": {
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "ClaimResponseAddItemDetail": {},
    "ClaimResponseAddItemDetailSubDetail": {},
    "ClaimResponseTotal": {},
    "ClaimResponsePayment": {},
    "ClaimResponseProcessNote": {},
    "ClaimResponseInsurance": {
      "coverage": {
        "referenceTypes": [
          "Coverage"
        ]
      },
      "claimResponse": {
        "referenceTypes": [
          "ClaimResponse"
        ]
      }
    },
    "ClaimResponseError": {},
    "MedicationRequest": {
      "reported": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Organization"
        ]
      },
      "medication": {
        "referenceTypes": [
          "Medication"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "supportingInformation": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "requester": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "RelatedPerson",
          "Device"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "Device",
          "RelatedPerson",
          "CareTeam"
        ]
      },
      "recorder": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation"
        ]
      },
      "basedOn": {
        "referenceTypes": [
          "CarePlan",
          "MedicationRequest",
          "ServiceRequest",
          "ImmunizationRecommendation"
        ]
      },
      "insurance": {
        "referenceTypes": [
          "Coverage",
          "ClaimResponse"
        ]
      },
      "priorPrescription": {
        "referenceTypes": [
          "MedicationRequest"
        ]
      },
      "detectedIssue": {
        "referenceTypes": [
          "DetectedIssue"
        ]
      },
      "eventHistory": {
        "referenceTypes": [
          "Provenance"
        ]
      }
    },
    "MedicationRequestDispenseRequest": {
      "performer": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "MedicationRequestDispenseRequestInitialFill": {},
    "MedicationRequestSubstitution": {},
    "MedicinalProductIndication": {
      "subject": {
        "referenceTypes": [
          "MedicinalProduct",
          "Medication"
        ]
      },
      "undesirableEffect": {
        "referenceTypes": [
          "MedicinalProductUndesirableEffect"
        ]
      }
    },
    "MedicinalProductIndicationOtherTherapy": {
      "medication": {
        "referenceTypes": [
          "MedicinalProduct",
          "Medication",
          "Substance",
          "SubstanceSpecification"
        ]
      }
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
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "associatedMedication": {
        "referenceTypes": [
          "Medication"
        ]
      },
      "contraindication": {
        "referenceTypes": [
          "DetectedIssue"
        ]
      }
    },
    "MedicationKnowledgeRelatedMedicationKnowledge": {
      "reference": {
        "referenceTypes": [
          "MedicationKnowledge"
        ]
      }
    },
    "MedicationKnowledgeMonograph": {
      "source": {
        "referenceTypes": [
          "DocumentReference",
          "Media"
        ]
      }
    },
    "MedicationKnowledgeIngredient": {
      "item": {
        "referenceTypes": [
          "Substance"
        ]
      }
    },
    "MedicationKnowledgeCost": {},
    "MedicationKnowledgeMonitoringProgram": {},
    "MedicationKnowledgeAdministrationGuidelines": {
      "indication": {
        "referenceTypes": [
          "ObservationDefinition"
        ]
      }
    },
    "MedicationKnowledgeAdministrationGuidelinesDosage": {},
    "MedicationKnowledgeAdministrationGuidelinesPatientCharacteristics": {},
    "MedicationKnowledgeMedicineClassification": {},
    "MedicationKnowledgePackaging": {},
    "MedicationKnowledgeDrugCharacteristic": {},
    "MedicationKnowledgeRegulatory": {
      "regulatoryAuthority": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "MedicationKnowledgeRegulatorySubstitution": {},
    "MedicationKnowledgeRegulatorySchedule": {},
    "MedicationKnowledgeRegulatoryMaxDispense": {},
    "MedicationKnowledgeKinetics": {},
    "ProductShelfLife": {},
    "Period": {},
    "DataRequirement": {
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      }
    },
    "DataRequirementCodeFilter": {},
    "DataRequirementDateFilter": {},
    "DataRequirementSort": {},
    "Linkage": {
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "LinkageItem": {
      "resource": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "Address": {},
    "Location": {
      "managingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "Location"
        ]
      },
      "endpoint": {
        "referenceTypes": [
          "Endpoint"
        ]
      }
    },
    "LocationPosition": {},
    "LocationHoursOfOperation": {},
    "GuidanceResponse": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Device"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      },
      "evaluationMessage": {
        "referenceTypes": [
          "OperationOutcome"
        ]
      },
      "outputParameters": {
        "referenceTypes": [
          "Parameters"
        ]
      },
      "result": {
        "referenceTypes": [
          "CarePlan",
          "RequestGroup"
        ]
      }
    },
    "Library": {
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      }
    },
    "ResearchElementDefinition": {
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      }
    },
    "ResearchElementDefinitionCharacteristic": {},
    "Signature": {
      "who": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Patient",
          "Device",
          "Organization"
        ]
      },
      "onBehalfOf": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Patient",
          "Device",
          "Organization"
        ]
      }
    },
    "Quantity": {},
    "HealthcareService": {
      "providedBy": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "coverageArea": {
        "referenceTypes": [
          "Location"
        ]
      },
      "endpoint": {
        "referenceTypes": [
          "Endpoint"
        ]
      }
    },
    "HealthcareServiceEligibility": {},
    "HealthcareServiceAvailableTime": {},
    "HealthcareServiceNotAvailable": {},
    "SubstanceReferenceInformation": {},
    "SubstanceReferenceInformationGene": {
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "SubstanceReferenceInformationGeneElement": {
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "SubstanceReferenceInformationClassification": {
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "SubstanceReferenceInformationTarget": {
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
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
      "ownedBy": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "administeredBy": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "coverageArea": {
        "referenceTypes": [
          "Location"
        ]
      },
      "endpoint": {
        "referenceTypes": [
          "Endpoint"
        ]
      },
      "network": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "InsurancePlanContact": {},
    "InsurancePlanCoverage": {
      "network": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "InsurancePlanCoverageBenefit": {},
    "InsurancePlanCoverageBenefitLimit": {},
    "InsurancePlanPlan": {
      "coverageArea": {
        "referenceTypes": [
          "Location"
        ]
      },
      "network": {
        "referenceTypes": [
          "Organization"
        ]
      }
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
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      }
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
      "substance": {
        "referenceTypes": [
          "Substance"
        ]
      }
    },
    "Distance": {},
    "BodyStructure": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      }
    },
    "Invoice": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "recipient": {
        "referenceTypes": [
          "Organization",
          "Patient",
          "RelatedPerson"
        ]
      },
      "issuer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "account": {
        "referenceTypes": [
          "Account"
        ]
      }
    },
    "InvoiceParticipant": {
      "actor": {
        "referenceTypes": [
          "Practitioner",
          "Organization",
          "Patient",
          "PractitionerRole",
          "Device",
          "RelatedPerson"
        ]
      }
    },
    "InvoiceLineItem": {
      "chargeItem": {
        "referenceTypes": [
          "ChargeItem"
        ]
      }
    },
    "InvoiceLineItemPriceComponent": {},
    "VerificationResult": {
      "target": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "VerificationResultPrimarySource": {
      "who": {
        "referenceTypes": [
          "Organization",
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "VerificationResultAttestation": {
      "who": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "onBehalfOf": {
        "referenceTypes": [
          "Organization",
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "VerificationResultValidator": {
      "organization": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "Ratio": {},
    "Encounter": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "episodeOfCare": {
        "referenceTypes": [
          "EpisodeOfCare"
        ]
      },
      "basedOn": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      },
      "appointment": {
        "referenceTypes": [
          "Appointment"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Procedure",
          "Observation",
          "ImmunizationRecommendation"
        ]
      },
      "account": {
        "referenceTypes": [
          "Account"
        ]
      },
      "serviceProvider": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "Encounter"
        ]
      }
    },
    "EncounterStatusHistory": {},
    "EncounterClassHistory": {},
    "EncounterParticipant": {
      "individual": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      }
    },
    "EncounterDiagnosis": {
      "condition": {
        "referenceTypes": [
          "Condition",
          "Procedure"
        ]
      }
    },
    "EncounterHospitalization": {
      "origin": {
        "referenceTypes": [
          "Location",
          "Organization"
        ]
      },
      "destination": {
        "referenceTypes": [
          "Location",
          "Organization"
        ]
      }
    },
    "EncounterLocation": {
      "location": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "Account": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Device",
          "Practitioner",
          "PractitionerRole",
          "Location",
          "HealthcareService",
          "Organization"
        ]
      },
      "owner": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "Account"
        ]
      }
    },
    "AccountCoverage": {
      "coverage": {
        "referenceTypes": [
          "Coverage"
        ]
      }
    },
    "AccountGuarantor": {
      "party": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Organization"
        ]
      }
    },
    "Flag": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Location",
          "Group",
          "Organization",
          "Practitioner",
          "PlanDefinition",
          "Medication",
          "Procedure"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "author": {
        "referenceTypes": [
          "Device",
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "EpisodeOfCare": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "managingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "referralRequest": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      },
      "careManager": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "team": {
        "referenceTypes": [
          "CareTeam"
        ]
      },
      "account": {
        "referenceTypes": [
          "Account"
        ]
      }
    },
    "EpisodeOfCareStatusHistory": {},
    "EpisodeOfCareDiagnosis": {
      "condition": {
        "referenceTypes": [
          "Condition"
        ]
      }
    },
    "MessageDefinition": {},
    "MessageDefinitionFocus": {},
    "MessageDefinitionAllowedResponse": {},
    "CapabilityStatement": {},
    "CapabilityStatementSoftware": {},
    "CapabilityStatementImplementation": {
      "custodian": {
        "referenceTypes": [
          "Organization"
        ]
      }
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
      "instantiatesCanonical": {
        "referenceTypes": [
          "Contract"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "authority": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "domain": {
        "referenceTypes": [
          "Location"
        ]
      },
      "site": {
        "referenceTypes": [
          "Location"
        ]
      },
      "author": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "topic": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "supportingInfo": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "relevantHistory": {
        "referenceTypes": [
          "Provenance"
        ]
      },
      "legallyBinding": {
        "referenceTypes": [
          "Composition",
          "DocumentReference",
          "QuestionnaireResponse",
          "Contract"
        ]
      }
    },
    "ContractContentDefinition": {
      "publisher": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "ContractTerm": {
      "topic": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ContractTermSecurityLabel": {},
    "ContractTermOffer": {
      "topic": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ContractTermOfferParty": {
      "reference": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Practitioner",
          "PractitionerRole",
          "Device",
          "Group",
          "Organization"
        ]
      }
    },
    "ContractTermOfferAnswer": {
      "value": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ContractTermAsset": {
      "typeReference": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ContractTermAssetContext": {
      "reference": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ContractTermAssetValuedItem": {
      "entity": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "responsible": {
        "referenceTypes": [
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      },
      "recipient": {
        "referenceTypes": [
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      }
    },
    "ContractTermAction": {
      "context": {
        "referenceTypes": [
          "Encounter",
          "EpisodeOfCare"
        ]
      },
      "requester": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Practitioner",
          "PractitionerRole",
          "Device",
          "Group",
          "Organization"
        ]
      },
      "performer": {
        "referenceTypes": [
          "RelatedPerson",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "CareTeam",
          "Device",
          "Substance",
          "Organization",
          "Location"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference",
          "Questionnaire",
          "QuestionnaireResponse"
        ]
      }
    },
    "ContractTermActionSubject": {
      "reference": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Practitioner",
          "PractitionerRole",
          "Device",
          "Group",
          "Organization"
        ]
      }
    },
    "ContractSigner": {
      "party": {
        "referenceTypes": [
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      }
    },
    "ContractFriendly": {
      "content": {
        "referenceTypes": [
          "Composition",
          "DocumentReference",
          "QuestionnaireResponse"
        ]
      }
    },
    "ContractLegal": {
      "content": {
        "referenceTypes": [
          "Composition",
          "DocumentReference",
          "QuestionnaireResponse"
        ]
      }
    },
    "ContractRule": {
      "content": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "ChargeItem": {
      "partOf": {
        "referenceTypes": [
          "ChargeItem"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "context": {
        "referenceTypes": [
          "Encounter",
          "EpisodeOfCare"
        ]
      },
      "performingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "requestingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "costCenter": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "enterer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "Device",
          "RelatedPerson"
        ]
      },
      "service": {
        "referenceTypes": [
          "DiagnosticReport",
          "ImagingStudy",
          "Immunization",
          "MedicationAdministration",
          "MedicationDispense",
          "Observation",
          "Procedure",
          "SupplyDelivery"
        ]
      },
      "product": {
        "referenceTypes": [
          "Device",
          "Medication",
          "Substance"
        ]
      },
      "account": {
        "referenceTypes": [
          "Account"
        ]
      },
      "supportingInformation": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ChargeItemPerformer": {
      "actor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam",
          "Patient",
          "Device",
          "RelatedPerson"
        ]
      }
    },
    "TestScript": {
      "profile": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "TestScriptOrigin": {},
    "TestScriptDestination": {},
    "TestScriptMetadata": {},
    "TestScriptMetadataLink": {},
    "TestScriptMetadataCapability": {},
    "TestScriptFixture": {
      "resource": {
        "referenceTypes": [
          "Resource"
        ]
      }
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
      "basedOn": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "Task"
        ]
      },
      "focus": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "for": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "requester": {
        "referenceTypes": [
          "Device",
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      },
      "owner": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam",
          "HealthcareService",
          "Patient",
          "Device",
          "RelatedPerson"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "insurance": {
        "referenceTypes": [
          "Coverage",
          "ClaimResponse"
        ]
      },
      "relevantHistory": {
        "referenceTypes": [
          "Provenance"
        ]
      }
    },
    "TaskRestriction": {
      "recipient": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Group",
          "Organization"
        ]
      }
    },
    "TaskInput": {},
    "TaskOutput": {},
    "Appointment": {
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Procedure",
          "Observation",
          "ImmunizationRecommendation"
        ]
      },
      "supportingInformation": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "slot": {
        "referenceTypes": [
          "Slot"
        ]
      },
      "basedOn": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      }
    },
    "AppointmentParticipant": {
      "actor": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Device",
          "HealthcareService",
          "Location"
        ]
      }
    },
    "Coverage": {
      "policyHolder": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Organization"
        ]
      },
      "subscriber": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson"
        ]
      },
      "beneficiary": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "payor": {
        "referenceTypes": [
          "Organization",
          "Patient",
          "RelatedPerson"
        ]
      },
      "contract": {
        "referenceTypes": [
          "Contract"
        ]
      }
    },
    "CoverageClass": {},
    "CoverageCostToBeneficiary": {},
    "CoverageCostToBeneficiaryException": {},
    "SupplyDelivery": {
      "basedOn": {
        "referenceTypes": [
          "SupplyRequest"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "SupplyDelivery",
          "Contract"
        ]
      },
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "supplier": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "destination": {
        "referenceTypes": [
          "Location"
        ]
      },
      "receiver": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "SupplyDeliverySuppliedItem": {
      "item": {
        "referenceTypes": [
          "Medication",
          "Substance",
          "Device"
        ]
      }
    },
    "ImmunizationRecommendation": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "authority": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "ImmunizationRecommendationRecommendation": {
      "supportingImmunization": {
        "referenceTypes": [
          "Immunization",
          "ImmunizationEvaluation"
        ]
      },
      "supportingPatientInformation": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ImmunizationRecommendationRecommendationDateCriterion": {},
    "Evidence": {
      "exposureBackground": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      },
      "exposureVariant": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      },
      "outcome": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      }
    },
    "RiskAssessment": {
      "basedOn": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "parent": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "condition": {
        "referenceTypes": [
          "Condition"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Device"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      },
      "basis": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "RiskAssessmentPrediction": {},
    "Identifier": {
      "assigner": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "Organization": {
      "partOf": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "endpoint": {
        "referenceTypes": [
          "Endpoint"
        ]
      }
    },
    "OrganizationContact": {},
    "ImagingStudy": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Device",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "basedOn": {
        "referenceTypes": [
          "CarePlan",
          "ServiceRequest",
          "Appointment",
          "AppointmentResponse",
          "Task"
        ]
      },
      "referrer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "interpreter": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "endpoint": {
        "referenceTypes": [
          "Endpoint"
        ]
      },
      "procedureReference": {
        "referenceTypes": [
          "Procedure"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "Media",
          "DiagnosticReport",
          "DocumentReference"
        ]
      }
    },
    "ImagingStudySeries": {
      "endpoint": {
        "referenceTypes": [
          "Endpoint"
        ]
      },
      "specimen": {
        "referenceTypes": [
          "Specimen"
        ]
      }
    },
    "ImagingStudySeriesPerformer": {
      "actor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam",
          "Patient",
          "Device",
          "RelatedPerson"
        ]
      }
    },
    "ImagingStudySeriesInstance": {},
    "AuditEvent": {},
    "AuditEventAgent": {
      "who": {
        "referenceTypes": [
          "PractitionerRole",
          "Practitioner",
          "Organization",
          "Device",
          "Patient",
          "RelatedPerson"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "AuditEventAgentNetwork": {},
    "AuditEventSource": {
      "observer": {
        "referenceTypes": [
          "PractitionerRole",
          "Practitioner",
          "Organization",
          "Device",
          "Patient",
          "RelatedPerson"
        ]
      }
    },
    "AuditEventEntity": {
      "what": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "AuditEventEntityDetail": {},
    "MedicinalProductPharmaceutical": {
      "ingredient": {
        "referenceTypes": [
          "MedicinalProductIngredient"
        ]
      },
      "device": {
        "referenceTypes": [
          "DeviceDefinition"
        ]
      }
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
      "managingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "PersonLink": {
      "target": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "RelatedPerson",
          "Person"
        ]
      }
    },
    "Provenance": {
      "target": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "ProvenanceAgent": {
      "who": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Patient",
          "Device",
          "Organization"
        ]
      },
      "onBehalfOf": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Patient",
          "Device",
          "Organization"
        ]
      }
    },
    "ProvenanceEntity": {
      "what": {
        "referenceTypes": [
          "Resource"
        ]
      }
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
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      },
      "population": {
        "referenceTypes": [
          "ResearchElementDefinition"
        ]
      },
      "exposure": {
        "referenceTypes": [
          "ResearchElementDefinition"
        ]
      },
      "exposureAlternative": {
        "referenceTypes": [
          "ResearchElementDefinition"
        ]
      },
      "outcome": {
        "referenceTypes": [
          "ResearchElementDefinition"
        ]
      }
    },
    "ServiceRequest": {
      "basedOn": {
        "referenceTypes": [
          "CarePlan",
          "ServiceRequest",
          "MedicationRequest"
        ]
      },
      "replaces": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group",
          "Location",
          "Device"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "requester": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "RelatedPerson",
          "Device"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam",
          "HealthcareService",
          "Patient",
          "Device",
          "RelatedPerson"
        ]
      },
      "locationReference": {
        "referenceTypes": [
          "Location"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      },
      "insurance": {
        "referenceTypes": [
          "Coverage",
          "ClaimResponse"
        ]
      },
      "supportingInfo": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "specimen": {
        "referenceTypes": [
          "Specimen"
        ]
      },
      "relevantHistory": {
        "referenceTypes": [
          "Provenance"
        ]
      }
    },
    "CommunicationRequest": {
      "basedOn": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "replaces": {
        "referenceTypes": [
          "CommunicationRequest"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "about": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "requester": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "RelatedPerson",
          "Device"
        ]
      },
      "recipient": {
        "referenceTypes": [
          "Device",
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Group",
          "CareTeam",
          "HealthcareService"
        ]
      },
      "sender": {
        "referenceTypes": [
          "Device",
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "HealthcareService"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      }
    },
    "CommunicationRequestPayload": {
      "content": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "MedicinalProductContraindication": {
      "subject": {
        "referenceTypes": [
          "MedicinalProduct",
          "Medication"
        ]
      },
      "therapeuticIndication": {
        "referenceTypes": [
          "MedicinalProductIndication"
        ]
      }
    },
    "MedicinalProductContraindicationOtherTherapy": {
      "medication": {
        "referenceTypes": [
          "MedicinalProduct",
          "Medication",
          "Substance",
          "SubstanceSpecification"
        ]
      }
    },
    "EnrollmentRequest": {
      "insurer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "candidate": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "coverage": {
        "referenceTypes": [
          "Coverage"
        ]
      }
    },
    "ElementDefinitionExtension": {},
    "VisionPrescription": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "prescriber": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "VisionPrescriptionLensSpecification": {},
    "VisionPrescriptionLensSpecificationPrism": {},
    "ProdCharacteristic": {},
    "FamilyMemberHistory": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "AllergyIntolerance",
          "QuestionnaireResponse",
          "DiagnosticReport",
          "DocumentReference"
        ]
      }
    },
    "FamilyMemberHistoryCondition": {},
    "Element": {},
    "MedicinalProductUndesirableEffect": {
      "subject": {
        "referenceTypes": [
          "MedicinalProduct",
          "Medication"
        ]
      }
    },
    "RiskEvidenceSynthesis": {
      "population": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      },
      "exposure": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      },
      "outcome": {
        "referenceTypes": [
          "EvidenceVariable"
        ]
      }
    },
    "RiskEvidenceSynthesisSampleSize": {},
    "RiskEvidenceSynthesisRiskEstimate": {},
    "RiskEvidenceSynthesisRiskEstimatePrecisionEstimate": {},
    "RiskEvidenceSynthesisCertainty": {},
    "RiskEvidenceSynthesisCertaintyCertaintySubcomponent": {},
    "CompartmentDefinition": {},
    "CompartmentDefinitionResource": {},
    "Binary": {
      "securityContext": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "Questionnaire": {},
    "QuestionnaireItem": {},
    "QuestionnaireItemEnableWhen": {
      "answer": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "QuestionnaireItemAnswerOption": {
      "value": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "QuestionnaireItemInitial": {
      "value": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "Specimen": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group",
          "Device",
          "Substance",
          "Location"
        ]
      },
      "parent": {
        "referenceTypes": [
          "Specimen"
        ]
      },
      "request": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      }
    },
    "SpecimenCollection": {
      "collector": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "SpecimenProcessing": {
      "additive": {
        "referenceTypes": [
          "Substance"
        ]
      }
    },
    "SpecimenContainer": {
      "additive": {
        "referenceTypes": [
          "Substance"
        ]
      }
    },
    "RequestGroup": {
      "basedOn": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "replaces": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "author": {
        "referenceTypes": [
          "Device",
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      }
    },
    "RequestGroupAction": {
      "participant": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Device"
        ]
      },
      "resource": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "RequestGroupActionCondition": {},
    "RequestGroupActionRelatedAction": {},
    "ExplanationOfBenefit": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "enterer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "insurer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "prescription": {
        "referenceTypes": [
          "MedicationRequest",
          "VisionPrescription"
        ]
      },
      "originalPrescription": {
        "referenceTypes": [
          "MedicationRequest"
        ]
      },
      "referral": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      },
      "facility": {
        "referenceTypes": [
          "Location"
        ]
      },
      "claim": {
        "referenceTypes": [
          "Claim"
        ]
      },
      "claimResponse": {
        "referenceTypes": [
          "ClaimResponse"
        ]
      }
    },
    "ExplanationOfBenefitRelated": {
      "claim": {
        "referenceTypes": [
          "Claim"
        ]
      }
    },
    "ExplanationOfBenefitPayee": {
      "party": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "RelatedPerson"
        ]
      }
    },
    "ExplanationOfBenefitCareTeam": {
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "ExplanationOfBenefitSupportingInfo": {
      "value": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ExplanationOfBenefitDiagnosis": {
      "diagnosis": {
        "referenceTypes": [
          "Condition"
        ]
      }
    },
    "ExplanationOfBenefitProcedure": {
      "procedure": {
        "referenceTypes": [
          "Procedure"
        ]
      },
      "udi": {
        "referenceTypes": [
          "Device"
        ]
      }
    },
    "ExplanationOfBenefitInsurance": {
      "coverage": {
        "referenceTypes": [
          "Coverage"
        ]
      }
    },
    "ExplanationOfBenefitAccident": {
      "location": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "ExplanationOfBenefitItem": {
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "udi": {
        "referenceTypes": [
          "Device"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      }
    },
    "ExplanationOfBenefitItemAdjudication": {},
    "ExplanationOfBenefitItemDetail": {
      "udi": {
        "referenceTypes": [
          "Device"
        ]
      }
    },
    "ExplanationOfBenefitItemDetailSubDetail": {
      "udi": {
        "referenceTypes": [
          "Device"
        ]
      }
    },
    "ExplanationOfBenefitAddItem": {
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "ExplanationOfBenefitAddItemDetail": {},
    "ExplanationOfBenefitAddItemDetailSubDetail": {},
    "ExplanationOfBenefitTotal": {},
    "ExplanationOfBenefitPayment": {},
    "ExplanationOfBenefitProcessNote": {},
    "ExplanationOfBenefitBenefitBalance": {},
    "ExplanationOfBenefitBenefitBalanceFinancial": {},
    "Consent": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Organization",
          "Patient",
          "Practitioner",
          "RelatedPerson",
          "PractitionerRole"
        ]
      },
      "organization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "source": {
        "referenceTypes": [
          "Consent",
          "DocumentReference",
          "Contract",
          "QuestionnaireResponse"
        ]
      }
    },
    "ConsentPolicy": {},
    "ConsentVerification": {
      "verifiedWith": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson"
        ]
      }
    },
    "ConsentProvision": {},
    "ConsentProvisionActor": {
      "reference": {
        "referenceTypes": [
          "Device",
          "Group",
          "CareTeam",
          "Organization",
          "Patient",
          "Practitioner",
          "RelatedPerson",
          "PractitionerRole"
        ]
      }
    },
    "ConsentProvisionData": {
      "reference": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "MedicinalProduct": {
      "pharmaceuticalProduct": {
        "referenceTypes": [
          "MedicinalProductPharmaceutical"
        ]
      },
      "packagedMedicinalProduct": {
        "referenceTypes": [
          "MedicinalProductPackaged"
        ]
      },
      "attachedDocument": {
        "referenceTypes": [
          "DocumentReference"
        ]
      },
      "masterFile": {
        "referenceTypes": [
          "DocumentReference"
        ]
      },
      "contact": {
        "referenceTypes": [
          "Organization",
          "PractitionerRole"
        ]
      },
      "clinicalTrial": {
        "referenceTypes": [
          "ResearchStudy"
        ]
      }
    },
    "MedicinalProductName": {},
    "MedicinalProductNameNamePart": {},
    "MedicinalProductNameCountryLanguage": {},
    "MedicinalProductManufacturingBusinessOperation": {
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "regulator": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "MedicinalProductSpecialDesignation": {
      "indication": {
        "referenceTypes": [
          "MedicinalProductIndication"
        ]
      }
    },
    "NamingSystem": {},
    "NamingSystemUniqueId": {},
    "ResearchStudy": {
      "protocol": {
        "referenceTypes": [
          "PlanDefinition"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "ResearchStudy"
        ]
      },
      "enrollment": {
        "referenceTypes": [
          "Group"
        ]
      },
      "sponsor": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "principalInvestigator": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "site": {
        "referenceTypes": [
          "Location"
        ]
      }
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
      "practitioner": {
        "referenceTypes": [
          "Practitioner"
        ]
      },
      "organization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "healthcareService": {
        "referenceTypes": [
          "HealthcareService"
        ]
      },
      "endpoint": {
        "referenceTypes": [
          "Endpoint"
        ]
      }
    },
    "PractitionerRoleAvailableTime": {},
    "PractitionerRoleNotAvailable": {},
    "AdverseEvent": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group",
          "Practitioner",
          "RelatedPerson"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "resultingCondition": {
        "referenceTypes": [
          "Condition"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "recorder": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      },
      "contributor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Device"
        ]
      },
      "subjectMedicalHistory": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "AllergyIntolerance",
          "FamilyMemberHistory",
          "Immunization",
          "Procedure",
          "Media",
          "DocumentReference"
        ]
      },
      "referenceDocument": {
        "referenceTypes": [
          "DocumentReference"
        ]
      },
      "study": {
        "referenceTypes": [
          "ResearchStudy"
        ]
      }
    },
    "AdverseEventSuspectEntity": {
      "instance": {
        "referenceTypes": [
          "Immunization",
          "Procedure",
          "Substance",
          "Medication",
          "MedicationAdministration",
          "MedicationStatement",
          "Device"
        ]
      }
    },
    "AdverseEventSuspectEntityCausality": {
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "TriggerDefinition": {
      "timing": {
        "referenceTypes": [
          "Schedule"
        ]
      }
    },
    "ResearchSubject": {
      "study": {
        "referenceTypes": [
          "ResearchStudy"
        ]
      },
      "individual": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "consent": {
        "referenceTypes": [
          "Consent"
        ]
      }
    },
    "Money": {},
    "Resource": {},
    "ImplementationGuide": {},
    "ImplementationGuideDependsOn": {},
    "ImplementationGuideGlobal": {},
    "ImplementationGuideDefinition": {},
    "ImplementationGuideDefinitionGrouping": {},
    "ImplementationGuideDefinitionResource": {
      "reference": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ImplementationGuideDefinitionPage": {
      "name": {
        "referenceTypes": [
          "Binary"
        ]
      }
    },
    "ImplementationGuideDefinitionParameter": {},
    "ImplementationGuideDefinitionTemplate": {},
    "ImplementationGuideManifest": {},
    "ImplementationGuideManifestResource": {
      "reference": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "ImplementationGuideManifestPage": {},
    "MedicinalProductIngredient": {
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "MedicinalProductIngredientSpecifiedSubstance": {},
    "MedicinalProductIngredientSpecifiedSubstanceStrength": {},
    "MedicinalProductIngredientSpecifiedSubstanceStrengthReferenceStrength": {},
    "MedicinalProductIngredientSubstance": {},
    "Group": {
      "managingEntity": {
        "referenceTypes": [
          "Organization",
          "RelatedPerson",
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "GroupCharacteristic": {},
    "GroupMember": {
      "entity": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "Device",
          "Medication",
          "Substance",
          "Group"
        ]
      }
    },
    "MedicinalProductAuthorization": {
      "subject": {
        "referenceTypes": [
          "MedicinalProduct",
          "MedicinalProductPackaged"
        ]
      },
      "holder": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "regulator": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "MedicinalProductAuthorizationJurisdictionalAuthorization": {},
    "MedicinalProductAuthorizationProcedure": {},
    "Patient": {
      "generalPractitioner": {
        "referenceTypes": [
          "Organization",
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "managingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "PatientContact": {
      "organization": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "PatientCommunication": {},
    "PatientLink": {
      "other": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson"
        ]
      }
    },
    "HumanName": {},
    "EventDefinition": {
      "subject": {
        "referenceTypes": [
          "Group"
        ]
      }
    },
    "DeviceUseStatement": {
      "basedOn": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "derivedFrom": {
        "referenceTypes": [
          "ServiceRequest",
          "Procedure",
          "Claim",
          "Observation",
          "QuestionnaireResponse",
          "DocumentReference"
        ]
      },
      "source": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      },
      "device": {
        "referenceTypes": [
          "Device"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference",
          "Media"
        ]
      }
    },
    "BiologicallyDerivedProduct": {
      "request": {
        "referenceTypes": [
          "ServiceRequest"
        ]
      },
      "parent": {
        "referenceTypes": [
          "BiologicallyDerivedProduct"
        ]
      }
    },
    "BiologicallyDerivedProductCollection": {
      "collector": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "source": {
        "referenceTypes": [
          "Patient",
          "Organization"
        ]
      }
    },
    "BiologicallyDerivedProductProcessing": {
      "additive": {
        "referenceTypes": [
          "Substance"
        ]
      }
    },
    "BiologicallyDerivedProductManipulation": {},
    "BiologicallyDerivedProductStorage": {},
    "MessageHeader": {
      "sender": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "enterer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "responsible": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "focus": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "MessageHeaderDestination": {
      "target": {
        "referenceTypes": [
          "Device"
        ]
      },
      "receiver": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "MessageHeaderSource": {},
    "MessageHeaderResponse": {
      "details": {
        "referenceTypes": [
          "OperationOutcome"
        ]
      }
    },
    "SubstancePolymer": {},
    "SubstancePolymerMonomerSet": {},
    "SubstancePolymerMonomerSetStartingMaterial": {},
    "SubstancePolymerRepeat": {},
    "SubstancePolymerRepeatRepeatUnit": {},
    "SubstancePolymerRepeatRepeatUnitDegreeOfPolymerisation": {},
    "SubstancePolymerRepeatRepeatUnitStructuralRepresentation": {},
    "MedicinalProductPackaged": {
      "subject": {
        "referenceTypes": [
          "MedicinalProduct"
        ]
      },
      "marketingAuthorization": {
        "referenceTypes": [
          "MedicinalProductAuthorization"
        ]
      },
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "MedicinalProductPackagedBatchIdentifier": {},
    "MedicinalProductPackagedPackageItem": {
      "device": {
        "referenceTypes": [
          "DeviceDefinition"
        ]
      },
      "manufacturedItem": {
        "referenceTypes": [
          "MedicinalProductManufactured"
        ]
      },
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "RelatedArtifact": {},
    "MedicinalProductManufactured": {
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "ingredient": {
        "referenceTypes": [
          "MedicinalProductIngredient"
        ]
      }
    },
    "SubstanceNucleicAcid": {},
    "SubstanceNucleicAcidSubunit": {},
    "SubstanceNucleicAcidSubunitLinkage": {},
    "SubstanceNucleicAcidSubunitSugar": {},
    "Population": {},
    "Communication": {
      "basedOn": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "inResponseTo": {
        "referenceTypes": [
          "Communication"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "about": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "recipient": {
        "referenceTypes": [
          "Device",
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Group",
          "CareTeam",
          "HealthcareService"
        ]
      },
      "sender": {
        "referenceTypes": [
          "Device",
          "Organization",
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "HealthcareService"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      }
    },
    "CommunicationPayload": {
      "content": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "OperationDefinition": {},
    "OperationDefinitionParameter": {},
    "OperationDefinitionParameterBinding": {},
    "OperationDefinitionParameterReferencedFrom": {},
    "OperationDefinitionOverload": {},
    "DetectedIssue": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Device"
        ]
      },
      "implicated": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "DetectedIssueEvidence": {
      "detail": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "DetectedIssueMitigation": {
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "Procedure": {
      "basedOn": {
        "referenceTypes": [
          "CarePlan",
          "ServiceRequest"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "Procedure",
          "Observation",
          "MedicationAdministration"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "recorder": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "asserter": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "Procedure",
          "DiagnosticReport",
          "DocumentReference"
        ]
      },
      "report": {
        "referenceTypes": [
          "DiagnosticReport",
          "DocumentReference",
          "Composition"
        ]
      },
      "complicationDetail": {
        "referenceTypes": [
          "Condition"
        ]
      },
      "usedReference": {
        "referenceTypes": [
          "Device",
          "Medication",
          "Substance"
        ]
      }
    },
    "ProcedurePerformer": {
      "actor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "RelatedPerson",
          "Device"
        ]
      },
      "onBehalfOf": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "ProcedureFocalDevice": {
      "manipulated": {
        "referenceTypes": [
          "Device"
        ]
      }
    },
    "OrganizationAffiliation": {
      "organization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "participatingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "network": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "healthcareService": {
        "referenceTypes": [
          "HealthcareService"
        ]
      },
      "endpoint": {
        "referenceTypes": [
          "Endpoint"
        ]
      }
    },
    "MeasureReport": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "Location",
          "Device",
          "RelatedPerson",
          "Group"
        ]
      },
      "reporter": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Location",
          "Organization"
        ]
      },
      "evaluatedResource": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "MeasureReportGroup": {},
    "MeasureReportGroupPopulation": {
      "subjectResults": {
        "referenceTypes": [
          "List"
        ]
      }
    },
    "MeasureReportGroupStratifier": {},
    "MeasureReportGroupStratifierStratum": {},
    "MeasureReportGroupStratifierStratumComponent": {},
    "MeasureReportGroupStratifierStratumPopulation": {
      "subjectResults": {
        "referenceTypes": [
          "List"
        ]
      }
    },
    "MedicationStatement": {
      "basedOn": {
        "referenceTypes": [
          "MedicationRequest",
          "CarePlan",
          "ServiceRequest"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "MedicationAdministration",
          "MedicationDispense",
          "MedicationStatement",
          "Procedure",
          "Observation"
        ]
      },
      "medication": {
        "referenceTypes": [
          "Medication"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "context": {
        "referenceTypes": [
          "Encounter",
          "EpisodeOfCare"
        ]
      },
      "informationSource": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Organization"
        ]
      },
      "derivedFrom": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport"
        ]
      }
    },
    "DeviceDefinition": {
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "owner": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "parentDevice": {
        "referenceTypes": [
          "DeviceDefinition"
        ]
      }
    },
    "DeviceDefinitionUdiDeviceIdentifier": {},
    "DeviceDefinitionDeviceName": {},
    "DeviceDefinitionSpecialization": {},
    "DeviceDefinitionCapability": {},
    "DeviceDefinitionProperty": {},
    "DeviceDefinitionMaterial": {},
    "CatalogEntry": {
      "referencedItem": {
        "referenceTypes": [
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
      }
    },
    "CatalogEntryRelatedEntry": {
      "item": {
        "referenceTypes": [
          "CatalogEntry"
        ]
      }
    },
    "Slot": {
      "schedule": {
        "referenceTypes": [
          "Schedule"
        ]
      }
    },
    "CoverageEligibilityRequest": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "enterer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "insurer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "facility": {
        "referenceTypes": [
          "Location"
        ]
      }
    },
    "CoverageEligibilityRequestSupportingInfo": {
      "information": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "CoverageEligibilityRequestInsurance": {
      "coverage": {
        "referenceTypes": [
          "Coverage"
        ]
      }
    },
    "CoverageEligibilityRequestItem": {
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "facility": {
        "referenceTypes": [
          "Location",
          "Organization"
        ]
      },
      "detail": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "CoverageEligibilityRequestItemDiagnosis": {
      "diagnosis": {
        "referenceTypes": [
          "Condition"
        ]
      }
    },
    "MedicinalProductInteraction": {
      "subject": {
        "referenceTypes": [
          "MedicinalProduct",
          "Medication",
          "Substance"
        ]
      }
    },
    "MedicinalProductInteractionInteractant": {
      "item": {
        "referenceTypes": [
          "MedicinalProduct",
          "Medication",
          "Substance",
          "ObservationDefinition"
        ]
      }
    },
    "List": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group",
          "Device",
          "Location"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "source": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Patient",
          "Device"
        ]
      }
    },
    "ListEntry": {
      "item": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "Subscription": {},
    "SubscriptionChannel": {},
    "ExtensionExtensionExtension": {},
    "Duration": {},
    "Age": {},
    "SampledData": {},
    "EnrollmentResponse": {
      "request": {
        "referenceTypes": [
          "EnrollmentRequest"
        ]
      },
      "organization": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "requestProvider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "Practitioner": {},
    "PractitionerQualification": {
      "issuer": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "TestReport": {
      "testScript": {
        "referenceTypes": [
          "TestScript"
        ]
      }
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
      "definition": {
        "referenceTypes": [
          "DeviceDefinition"
        ]
      },
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "owner": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "parent": {
        "referenceTypes": [
          "Device"
        ]
      }
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
      "partOf": {
        "referenceTypes": [
          "MedicationAdministration",
          "Procedure"
        ]
      },
      "medication": {
        "referenceTypes": [
          "Medication"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "context": {
        "referenceTypes": [
          "Encounter",
          "EpisodeOfCare"
        ]
      },
      "supportingInformation": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport"
        ]
      },
      "request": {
        "referenceTypes": [
          "MedicationRequest"
        ]
      },
      "device": {
        "referenceTypes": [
          "Device"
        ]
      },
      "eventHistory": {
        "referenceTypes": [
          "Provenance"
        ]
      }
    },
    "MedicationAdministrationPerformer": {
      "actor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Patient",
          "RelatedPerson",
          "Device"
        ]
      }
    },
    "MedicationAdministrationDosage": {},
    "Reference": {},
    "NutritionOrder": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "orderer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      },
      "allergyIntolerance": {
        "referenceTypes": [
          "AllergyIntolerance"
        ]
      }
    },
    "NutritionOrderOralDiet": {},
    "NutritionOrderOralDietNutrient": {},
    "NutritionOrderOralDietTexture": {},
    "NutritionOrderSupplement": {},
    "NutritionOrderEnteralFormula": {},
    "NutritionOrderEnteralFormulaAdministration": {},
    "Range": {},
    "Immunization": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "manufacturer": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport"
        ]
      }
    },
    "ImmunizationPerformer": {
      "actor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      }
    },
    "ImmunizationEducation": {},
    "ImmunizationReaction": {
      "detail": {
        "referenceTypes": [
          "Observation"
        ]
      }
    },
    "ImmunizationProtocolApplied": {
      "authority": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "SpecimenDefinition": {},
    "SpecimenDefinitionTypeTested": {},
    "SpecimenDefinitionTypeTestedContainer": {},
    "SpecimenDefinitionTypeTestedContainerAdditive": {
      "additive": {
        "referenceTypes": [
          "Substance"
        ]
      }
    },
    "SpecimenDefinitionTypeTestedHandling": {},
    "Narrative": {},
    "Endpoint": {
      "managingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "Goal": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group",
          "Organization"
        ]
      },
      "expressedBy": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      },
      "addresses": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "MedicationStatement",
          "NutritionOrder",
          "ServiceRequest",
          "RiskAssessment"
        ]
      },
      "outcomeReference": {
        "referenceTypes": [
          "Observation"
        ]
      }
    },
    "GoalTarget": {},
    "Expression": {},
    "AllergyIntolerance": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "recorder": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Patient",
          "RelatedPerson"
        ]
      },
      "asserter": {
        "referenceTypes": [
          "Patient",
          "RelatedPerson",
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "AllergyIntoleranceReaction": {},
    "ParameterDefinition": {},
    "ImmunizationEvaluation": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "authority": {
        "referenceTypes": [
          "Organization"
        ]
      },
      "immunizationEvent": {
        "referenceTypes": [
          "Immunization"
        ]
      }
    },
    "DeviceRequest": {
      "basedOn": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "priorRequest": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "code": {
        "referenceTypes": [
          "Device"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group",
          "Location",
          "Device"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "requester": {
        "referenceTypes": [
          "Device",
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam",
          "HealthcareService",
          "Patient",
          "Device",
          "RelatedPerson"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      },
      "insurance": {
        "referenceTypes": [
          "Coverage",
          "ClaimResponse"
        ]
      },
      "supportingInfo": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "relevantHistory": {
        "referenceTypes": [
          "Provenance"
        ]
      }
    },
    "DeviceRequestParameter": {},
    "CoverageEligibilityResponse": {
      "patient": {
        "referenceTypes": [
          "Patient"
        ]
      },
      "requestor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "request": {
        "referenceTypes": [
          "CoverageEligibilityRequest"
        ]
      },
      "insurer": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "CoverageEligibilityResponseInsurance": {
      "coverage": {
        "referenceTypes": [
          "Coverage"
        ]
      }
    },
    "CoverageEligibilityResponseInsuranceItem": {
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "CoverageEligibilityResponseInsuranceItemBenefit": {},
    "CoverageEligibilityResponseError": {},
    "Media": {
      "basedOn": {
        "referenceTypes": [
          "ServiceRequest",
          "CarePlan"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "Group",
          "Device",
          "Specimen",
          "Location"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "operator": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "CareTeam",
          "Patient",
          "Device",
          "RelatedPerson"
        ]
      },
      "device": {
        "referenceTypes": [
          "Device",
          "DeviceMetric",
          "Device"
        ]
      }
    },
    "MarketingStatus": {},
    "PaymentNotice": {
      "request": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "response": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "provider": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "payment": {
        "referenceTypes": [
          "PaymentReconciliation"
        ]
      },
      "payee": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization"
        ]
      },
      "recipient": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "SubstanceSpecification": {
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      },
      "referenceInformation": {
        "referenceTypes": [
          "SubstanceReferenceInformation"
        ]
      },
      "nucleicAcid": {
        "referenceTypes": [
          "SubstanceNucleicAcid"
        ]
      },
      "polymer": {
        "referenceTypes": [
          "SubstancePolymer"
        ]
      },
      "protein": {
        "referenceTypes": [
          "SubstanceProtein"
        ]
      },
      "sourceMaterial": {
        "referenceTypes": [
          "SubstanceSourceMaterial"
        ]
      }
    },
    "SubstanceSpecificationMoiety": {},
    "SubstanceSpecificationProperty": {
      "definingSubstance": {
        "referenceTypes": [
          "SubstanceSpecification",
          "Substance"
        ]
      }
    },
    "SubstanceSpecificationStructure": {
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "SubstanceSpecificationStructureIsotope": {},
    "SubstanceSpecificationStructureIsotopeMolecularWeight": {},
    "SubstanceSpecificationStructureRepresentation": {},
    "SubstanceSpecificationCode": {
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "SubstanceSpecificationName": {
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "SubstanceSpecificationNameOfficial": {},
    "SubstanceSpecificationRelationship": {
      "substance": {
        "referenceTypes": [
          "SubstanceSpecification"
        ]
      },
      "source": {
        "referenceTypes": [
          "DocumentReference"
        ]
      }
    },
    "Basic": {
      "subject": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "author": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Patient",
          "RelatedPerson",
          "Organization"
        ]
      }
    },
    "MedicationDispense": {
      "partOf": {
        "referenceTypes": [
          "Procedure"
        ]
      },
      "statusReason": {
        "referenceTypes": [
          "DetectedIssue"
        ]
      },
      "medication": {
        "referenceTypes": [
          "Medication"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "context": {
        "referenceTypes": [
          "Encounter",
          "EpisodeOfCare"
        ]
      },
      "supportingInformation": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "authorizingPrescription": {
        "referenceTypes": [
          "MedicationRequest"
        ]
      },
      "destination": {
        "referenceTypes": [
          "Location"
        ]
      },
      "receiver": {
        "referenceTypes": [
          "Patient",
          "Practitioner"
        ]
      },
      "detectedIssue": {
        "referenceTypes": [
          "DetectedIssue"
        ]
      },
      "eventHistory": {
        "referenceTypes": [
          "Provenance"
        ]
      }
    },
    "MedicationDispensePerformer": {
      "actor": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "Patient",
          "Device",
          "RelatedPerson"
        ]
      }
    },
    "MedicationDispenseSubstitution": {
      "responsibleParty": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole"
        ]
      }
    },
    "QuestionnaireResponse": {
      "basedOn": {
        "referenceTypes": [
          "CarePlan",
          "ServiceRequest"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "Observation",
          "Procedure"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "author": {
        "referenceTypes": [
          "Device",
          "Practitioner",
          "PractitionerRole",
          "Patient",
          "RelatedPerson",
          "Organization"
        ]
      },
      "source": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson"
        ]
      }
    },
    "QuestionnaireResponseItem": {},
    "QuestionnaireResponseItemAnswer": {
      "value": {
        "referenceTypes": [
          "Resource"
        ]
      }
    },
    "CareTeam": {
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "reasonReference": {
        "referenceTypes": [
          "Condition"
        ]
      },
      "managingOrganization": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "CareTeamParticipant": {
      "member": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "RelatedPerson",
          "Patient",
          "Organization",
          "CareTeam"
        ]
      },
      "onBehalfOf": {
        "referenceTypes": [
          "Organization"
        ]
      }
    },
    "CarePlan": {
      "basedOn": {
        "referenceTypes": [
          "CarePlan"
        ]
      },
      "replaces": {
        "referenceTypes": [
          "CarePlan"
        ]
      },
      "partOf": {
        "referenceTypes": [
          "CarePlan"
        ]
      },
      "subject": {
        "referenceTypes": [
          "Patient",
          "Group"
        ]
      },
      "encounter": {
        "referenceTypes": [
          "Encounter"
        ]
      },
      "author": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "Device",
          "RelatedPerson",
          "Organization",
          "CareTeam"
        ]
      },
      "contributor": {
        "referenceTypes": [
          "Patient",
          "Practitioner",
          "PractitionerRole",
          "Device",
          "RelatedPerson",
          "Organization",
          "CareTeam"
        ]
      },
      "careTeam": {
        "referenceTypes": [
          "CareTeam"
        ]
      },
      "addresses": {
        "referenceTypes": [
          "Condition"
        ]
      },
      "supportingInfo": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "goal": {
        "referenceTypes": [
          "Goal"
        ]
      }
    },
    "CarePlanActivity": {
      "outcomeReference": {
        "referenceTypes": [
          "Resource"
        ]
      },
      "reference": {
        "referenceTypes": [
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
      }
    },
    "CarePlanActivityDetail": {
      "reasonReference": {
        "referenceTypes": [
          "Condition",
          "Observation",
          "DiagnosticReport",
          "DocumentReference"
        ]
      },
      "goal": {
        "referenceTypes": [
          "Goal"
        ]
      },
      "location": {
        "referenceTypes": [
          "Location"
        ]
      },
      "performer": {
        "referenceTypes": [
          "Practitioner",
          "PractitionerRole",
          "Organization",
          "RelatedPerson",
          "Patient",
          "CareTeam",
          "HealthcareService",
          "Device"
        ]
      },
      "product": {
        "referenceTypes": [
          "Medication",
          "Substance"
        ]
      }
    }
  }