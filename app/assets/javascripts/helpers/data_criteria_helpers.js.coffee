@DataCriteriaHelpers = class DataCriteriaHelpers

  @PRIMARY_TIMING_ATTRIBUTES:
    AdverseEvent: { date: 'dateTime', detected: 'dateTime', recordedDate: 'dateTime' },
    AllergyIntolerance: { recordedDate: 'dateTime', lastOccurrence: 'dateTime' },
    Condition: { recordedDate: 'dateTime' },
    FamilyMemberHistory: { date: 'dateTime' },
    Coverage: { period: 'Period' },
    DiagnosticReport: { issued: 'instant' },
    ImagingStudy: { started: 'DateTime' },
    Observation: { issued: 'instant' },
    Specimen: { receivedTime: 'dateTime' },
    CarePlan: { period: 'Period', created: 'DateTime' },
    CareTeam: { period: 'Period' },
    Goal: { statusDate: 'date' },
    NutritionOrder: { dateTime: 'dateTime' },
    ServiceRequest: { authoredOn: 'dateTime' },
    Claim: { billablePeriod: 'Period', created: 'dateTime' },
    Communication: { sent: 'dateTime', received: 'dateTime' },
    CommunicationRequest: { authoredOn: 'dateTime' },
    DeviceRequest: { authoredOn: 'dateTime' },
    DeviceUseStatement: { recordedOn: 'dateTime' },
    Device: { manufactureDate: 'dateTime', expirationDate: 'dateTime' },
    Encounter: { period: 'Period' },
    Flag: { period: 'Period' },
    Immunization: { recorded: 'dateTime', expirationDate: 'date' },
    ImmunizationEvaluation: { date: 'dateTime' },
    ImmunizationRecommendation: { date: 'dateTime' },
    MedicationDispense: { whenPrepared: 'dateTime', whenHandedOver: 'dateTime' },
    MedicationRequest: { authoredOn: 'dateTime' },
    MedicationStatement: { dateAsserted: 'dateTime' },
    Practitioner: { birthDate: 'date' },
    PractitionerRole: { period: 'Period' },
    RelatedPerson: { period: 'Period', birthDate: 'date' },
    Task: { executionPeriod: 'Period', authoredOn: 'dateTime', lastModified: 'dateTime' }

  @DATA_ELEMENT_CATEGORIES:
    AdverseEvent: 'clinical summary'
    AllergyIntolerance: 'clinical summary'
    Condition: 'clinical summary'
    FamilyMemberHistory: 'clinical summary'
    Procedure: 'clinical summary'

    Coverage: 'financial support'

    BodyStructure: 'diagnostics'
    DiagnosticReport: 'diagnostics'
    ImagingStudy: 'diagnostics'
    Observation: 'diagnostics'
    Specimen: 'diagnostics'

    CarePlan: 'care provision'
    CareTeam: 'care provision'
    Goal: 'care provision'
    NutritionOrder: 'care provision'
    ServiceRequest: 'care provision'

    Claim: 'billing'

    Communication: 'request response'
    CommunicationRequest: 'request response'
    DeviceRequest: 'request response'
    DeviceUseStatement: 'request response'

    Location: 'providers entities'

    Device: 'material entities'
    Substance: 'material entities'

    Encounter: 'management'
    Flag: 'management'

    Immunization: 'medications'
    ImmunizationEvaluation: 'medications'
    ImmunizationRecommendation: 'medications'
    Medication: 'medications'
    MedicationAdministration: 'medications'
    MedicationDispense: 'medications'
    MedicationRequest: 'medications'
    MedicationStatement: 'medications'

    Patient: 'individuals'
    Practitioner: 'individuals'
    PractitionerRole: 'individuals'
    RelatedPerson: 'individuals'

    Task: 'workflow'

  @getPrimaryCodePath: (dataElement) ->
    return cqm.models[dataElement.fhir_resource?.getTypeName()]?.primaryCodePath

  @isPrimaryCodePathSupported: (dataElement) ->
# Bonnie doesn't support choice types in primary code path
    type = cqm.models[dataElement.fhir_resource?.getTypeName()]
    primaryCodePath = type?.primaryCodePath
    return false unless primaryCodePath?
    fieldInfo = type?.fieldInfo?.find((info) -> info.fieldName == primaryCodePath)
    return fieldInfo?.fieldTypeNames?.length == 1 && cqm.models.CodeableConcept.typeName == fieldInfo?.fieldTypeNames?[0]

  @getPrimaryCodes: (dataElement) ->
    return dataElement?.fhir_resource?.primaryCode?.coding || []

  @setPrimaryCodes: (dataElement, codes) ->
    codeableConcept = new cqm.models.CodeableConcept()
    codeableConcept.coding = codes
    dataElement?.fhir_resource?.primaryCode = codeableConcept

  @getAttributes: (dataElement) ->
    resourceType = dataElement.fhir_resource?.resourceType
    attributes = @DATA_ELEMENT_ATTRIBUTES[resourceType]?.sort((a, b) -> a.path.localeCompare(b.path))
    return attributes || []

  @getAttribute: (dataElement, path) ->
    resourceType = dataElement.fhir_resource?.resourceType
    return @DATA_ELEMENT_ATTRIBUTES[resourceType]?.find((attr) => attr.path is path)

  @stringifyType: (type, codeSystemMap) ->
    if type == null || type == undefined
      return 'null'

    if cqm.models.Reference.isReference(type)
      return "#{type.reference.value}"

    if cqm.models.Coding.isCoding(type)
      codeSystemName = codeSystemMap?[type.system?.value] || type.system?.value
      return "#{codeSystemName}: #{type.code?.value}"

    if type instanceof cqm.models.PrimitiveCode                      ||
        cqm.models.PrimitiveString.isPrimitiveString(type)           ||
        cqm.models.PrimitiveBoolean.isPrimitiveBoolean(type)         ||
        cqm.models.PrimitiveInteger.isPrimitiveInteger(type)         ||
        cqm.models.PrimitivePositiveInt.isPrimitivePositiveInt(type) ||
        cqm.models.PrimitiveUnsignedInt.isPrimitiveUnsignedInt(type) ||
        cqm.models.PrimitiveDecimal.isPrimitiveDecimal(type)         ||
        cqm.models.PrimitiveId.isPrimitiveId(type)                   ||
        cqm.models.PrimitiveUri.isPrimitiveUri(type)
      return "#{type.value}"

    if cqm.models.Duration.isDuration(type)  ||
        cqm.models.Age.isAge(type)           ||
        cqm.models.Quantity.isQuantity(type) ||
        cqm.models.SimpleQuantity.isSimpleQuantity(type)
      if !!type.unit?.value
        return "#{type.value?.value} '#{type.unit?.value}'"
      else
        return "#{type.value?.value}"

    if cqm.models.Range.isRange(type)
      return "#{type.low?.value?.value || '?'} - #{type.high?.value?.value || '?'} #{type.high?.unit?.value}"

    if cqm.models.Ratio.isRatio(type)
      return "#{type.numerator?.value?.value} '#{type.numerator?.unit?.value}' : #{type.denominator?.value?.value} '#{type.denominator?.unit?.value}'"

    if cqm.models.Period.isPeriod(type)
      lowString = if type.start? then @stringifyType(type.start) else "null"
      highString = if type.end? then @stringifyType(type.end) else "null"
      return "#{lowString} - #{highString}"

    if cqm.models.PrimitiveTime.isPrimitiveTime(type)
      [hour, minute] = type?.value.split(":")
      hour = parseInt(hour)
      period = 'AM'
      if hour == 0
        hour = 12
      else if hour >= 12
        hour -= 12
        period = 'PM'
      return "#{hour}:#{minute} #{period}"

    if cqm.models.PrimitiveDateTime.isPrimitiveDateTime(type) || cqm.models.PrimitiveInstant.isPrimitiveInstant(type)
      cqlValue = DataTypeHelpers.getCQLDateTimeFromString(type?.value)
      return moment.utc(cqlValue.toJSDate()).format('L LT')

    if cqm.models.PrimitiveDate.isPrimitiveDate(type)
      cqlValue = DataTypeHelpers.getCQLDateFromString(type?.value)
      return moment.utc(cqlValue.toJSDate()).format('L')

    if cqm.models.SampledData.isSampledData(type)
      return "origin : #{@stringifyType(type.origin)} |
              period : #{@stringifyType(type.period)} |
              dimensions : #{@stringifyType(type.dimensions)} |
              factor : #{@stringifyType(type.factor)} |
              lower limit : #{@stringifyType(type.lowerLimit)} |
              upper limit : #{@stringifyType(type.upperLimit)} |
              data : #{@stringifyType(type.data)}"

    if cqm.models.CodeableConcept.isCodeableConcept(type)
      return "[" + type.coding.map((coding) => "#{@stringifyType(coding, codeSystemMap)}").join(', ') + "]"

    if cqm.models.Timing.isTiming(type)
      return @stringifyTiming(type, codeSystemMap)

    if cqm.models.Dosage.isDosage(type)
      return @stringifyDosage(type, codeSystemMap)

    if cqm.models.Identifier.isIdentifier(type)
      return @stringifyIdentifier(type, codeSystemMap)

    if cqm.models.ObservationComponent.isObservationComponent(type)
      return @stringifyObservationComponent(type, codeSystemMap)

    if @isCompositeType(type.getTypeName?())
      return @stringifyCompositeValue(type, codeSystemMap)

    return JSON.stringify(type)

  @stringifyCompositeValue: (compositeValue, codeSystemMap) ->
    attrs = []
    @getCompositeAttributes(compositeValue.getTypeName()).forEach (attrDef) =>
      attributeName = attrDef.path
      attributeValue = compositeValue[attributeName]
      if cqm.models.SampledData.isSampledData(attributeValue)
        attrs.push("#{attributeName}: [#{@stringifyType(attributeValue, codeSystemMap)}]")
      else if attributeValue?
        attrs.push("#{attributeName}: #{@stringifyType(attributeValue, codeSystemMap)}")
    return attrs.join(" | ")

  @stringifyObservationComponent: (type, codeSystemMap) ->
    attrs = []
    if type.code?
      attrs.push("code: #{@stringifyType(type.code, codeSystemMap)}")
    if type.value?
      if cqm.models.SampledData.isSampledData(type.value)
        attrs.push("value: [#{@stringifyType(type.value, codeSystemMap)}]")
      else
        attrs.push("value: #{@stringifyType(type.value, codeSystemMap)}")
    return attrs.join(" | ")

  @stringifyDosage: (type, codeSystemMap) ->
    attrs = []
    if type.sequence?
      attrs.push("sequence: #{@stringifyType(type.sequence)}")
    if type.text?
      attrs.push("text: #{@stringifyType(type.text)}")
    if type.additionalInstruction?[0]?
      attrs.push("additionalInstruction: #{@stringifyType(type.additionalInstruction[0], codeSystemMap)}")
    if type.patientInstruction?
      attrs.push("patientInstruction: #{@stringifyType(type.patientInstruction)}")
    # Display dosage.timing as a separate chip/pass
    #      if type.timing?
    #        attrs.push("timing: #{@stringifyType(type.timing)}")
    if type.asNeeded?
      attrs.push("asNeeded: #{@stringifyType(type.asNeeded, codeSystemMap)}")
    if type.site?
      attrs.push("site: #{@stringifyType(type.site, codeSystemMap)}")
    if type.route?
      attrs.push("route: #{@stringifyType(type.route, codeSystemMap)}")
    if type.method?
      attrs.push("method: #{@stringifyType(type.method, codeSystemMap)}")
    if type.doseAndRate?[0]?.type?
      attrs.push("doseAndRate.type: #{@stringifyType(type.doseAndRate[0].type, codeSystemMap)}")
    if type.doseAndRate?[0]?.dose?
      attrs.push("doseAndRate.dose: #{@stringifyType(type.doseAndRate[0].dose)}")
    if type.doseAndRate?[0]?.rate?
      attrs.push("doseAndRate.rate: #{@stringifyType(type.doseAndRate[0].rate)}")
    if type?.maxDosePerPeriod?
      attrs.push("maxDosePerPeriod: #{@stringifyType(type.maxDosePerPeriod)}")
    if type?.maxDosePerAdministration?
      attrs.push("maxDosePerAdministration: #{@stringifyType(type.maxDosePerAdministration)}")
    if type?.maxDosePerLifetime?
      attrs.push("maxDosePerLifetime: #{@stringifyType(type.maxDosePerLifetime)}")
    return attrs.join(" | ")

  @stringifyTiming: (type, codeSystemMap) ->
    attrs = []
    if type?.event?[0]?
      attrs.push("event : #{@stringifyType(type.event[0])}")
    if type?.repeat?.bounds?
      attrs.push("repeat.bounds : #{@stringifyType(type.repeat.bounds)}")
    if type?.repeat?.count?
      attrs.push("repeat.count : #{@stringifyType(type.repeat.count)}")
    if type?.repeat?.countMax?
      attrs.push("repeat.countMax : #{@stringifyType(type.repeat.countMax)}")
    if type?.repeat?.duration?
      attrs.push("repeat.duration : #{@stringifyType(type.repeat.duration)}")
    if type?.repeat?.durationMax?
      attrs.push("repeat.durationMax : #{@stringifyType(type.repeat.durationMax)}")
    if type?.repeat?.durationUnit?
      attrs.push("repeat.durationUnit : #{@stringifyType(type.repeat.durationUnit, codeSystemMap)}")
    if type?.repeat?.frequency?
      attrs.push("repeat.frequency : #{@stringifyType(type.repeat.frequency)}")
    if type?.repeat?.frequencyMax?
      attrs.push("repeat.frequencyMax : #{@stringifyType(type.repeat.frequencyMax)}")
    if type?.repeat?.period?
      attrs.push("repeat.period : #{@stringifyType(type.repeat.period)}")
    if type?.repeat?.periodMax?
      attrs.push("repeat.periodMax : #{@stringifyType(type.repeat.periodMax)}")
    if type?.repeat?.periodUnit?
      attrs.push("repeat.periodUnit : #{@stringifyType(type.repeat.periodUnit)}")
    if type?.repeat?.dayOfWeek?[0]?
      attrs.push("repeat.dayOfWeek : #{@stringifyType(type.repeat.dayOfWeek[0])}")
    if type?.repeat?.timeOfDay?[0]?
      attrs.push("repeat.timeOfDay : #{@stringifyType(type.repeat.timeOfDay[0])}")
    if type?.repeat?.when?[0]?
      attrs.push("repeat.when : #{@stringifyType(type.repeat.when[0])}")
    if type?.repeat?.offset?
      attrs.push("repeat.offset : #{@stringifyType(type.repeat.offset)}")
    if type?.code?
      attrs.push("code: #{@stringifyType(type.code, codeSystemMap)}")
    return attrs.join(" | ")

  @stringifyIdentifier: (type, codeSystemMap) ->
    attrs = []
    if type.use?
      attrs.push("use: #{@stringifyType(type.use, codeSystemMap)}")
    if type.type?
      attrs.push("type: #{@stringifyType(type.type, codeSystemMap)}")
    if type.system?
      attrs.push("system: #{@stringifyType(type.system)}")
    if type.value?
      attrs.push("value: #{@stringifyType(type.value)}")
    if type.period?
      attrs.push("period: #{@stringifyType(type.period)}")
    if type.assigner?.display?
      attrs.push("assigner: #{type.assigner.display.value}")
    return attrs.join(" | ")

# Data element attributes per resource type.
# Each resource has an array of entries per attribute.
# An attribute entry has necessary metadata to view/edit.
#   path - attribute/element path, relative to the current resource
#   title - an element name show to the User, same as path for now
#   getValue(fhirResource) - (optional) getter accessor which returns a FHIR value for the attribute,
#      shall be compatible with an UI element
#   setValue(fhirResource, value) - (optional) setter accessor which updates the resource with a value from UI.
#      shall be compatible with an UI element
#   types - an array of types. A simple attribute would have just one type entry. A choice type would have multiple type entries.
#       The user will be shown a type name on the UI to choose and its used to create a right UI editor element.
#       See DataCriteriaAttributeEditorView._createInputViewForType
#   valueSets - optional value sets for bindings
  @DATA_ELEMENT_ATTRIBUTES:
    AdverseEvent: []
    AllergyIntolerance: [
      {
        path: 'clinicalStatus'
        types: [
          'CodeableConcept'
        ]
        valueSets: () -> [FhirValueSets.ALLERGYINTOLERANCE_CLINICAL_VS]
      },
      {
        path: 'onset'
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'verificationStatus',
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.ALLERGYINTOLERANCE_VERIFICATION_VS]
      }
    ]
    Condition: [
      {
        path: 'clinicalStatus'
        types: [
          'CodeableConcept'
        ]
        valueSets: () -> [FhirValueSets.CONDITION_CLINICAL_VS]
      },
      {
        path: 'verificationStatus',
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.CONDITION_VER_STATUS_VS]
      },
      {
        path: 'onset'
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'abatement',
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'bodySite',
        types: [
          'CodeableConcept'
        ]
        isArray: true
        valueSets: () -> [BodySiteValueSet.JSON]
      },
      {
        path: 'category',
        types: [
          'CodeableConcept'
        ]
        isArray: true
        valueSets: () -> [FhirValueSets.CONDITION_CATEGORY_VS]
      },
      {
        path: 'severity'
        types: [
          'CodeableConcept'
        ]
        valueSets: () -> [ConditionSeverityValueSet.JSON]
      },
      {
        path: 'recorder'
        types: ['Reference']
        referenceTypes: ['Practitioner', 'PractitionerRole', 'RelatedPerson']
      },
      {
        path: 'asserter'
        types: ['Reference']
        referenceTypes: ['Practitioner', 'PractitionerRole', 'RelatedPerson']
      }
    ]
    FamilyMemberHistory: []
    Procedure: [
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [FhirValueSets.EVENT_STATUS_VS]
      },
      {
        path: 'performed'
        types: ['DateTime', 'Period']
      },
      {
        path: 'category'
        types: ['CodeableConcept'],
        valueSets: () -> [FhirValueSets.PROCEDURE_CATEGORY_VS]
      },
      {
        path: 'statusReason'
        types: ['CodeableConcept'],
        valueSets: () -> [FhirValueSets.PROCEDURE_NOT_PERFORMED_REASON_VS]
      },
      {
        path: 'reasonCode'
        isArray: true
        types: ['CodeableConcept']
        valueSets: () -> [ProcedureReasonValueSet.JSON]
      },
      {
        path: 'usedCode',
        isArray: true
        types: ['CodeableConcept'],
        valueSets: () -> [DeviceKindValueSet.JSON]
      }
    ]
    Coverage: []
    BodyStructure: []
    DiagnosticReport: [
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [DiagnosticReportStatusValueSet.JSON]
      },
      {
        path: 'effective',
        types: ['DateTime', 'Period']
      },
      {
        path: 'encounter'
        types: ['Reference']
        referenceTypes: ['Encounter']
      },
      {
        path: 'category',
        types: ['CodeableConcept']
        isArray: true
# Value Set from FHIR and QI Core DiagnosticReport Lab  http://hl7.org/fhir/ValueSet/diagnostic-service-sections
# Value Set from QI Core DiagnosticReport Note (http://hl7.org/fhir/us/qicore/StructureDefinition-qicore-diagnosticreport-note.html)
#     http://hl7.org/fhir/us/core/ValueSet/us-core-diagnosticreport-category
        valueSets: () -> [DiagnosticServiceSectionCodesValueSet.JSON, USCoreDiagnosticReportCategoryValueSet.JSON]
      }
    ]
    ImagingStudy: []
    Observation: [
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [ObservationStatusValueSet.JSON]
      },
      {
        path: 'value'
        types: ['Boolean', 'CodeableConcept', 'DateTime', 'Integer', 'Period',
          'Quantity', 'Range', 'Ratio', 'SampledData', 'String', 'Time'],
        valueSets: () -> []
      },
      {
        path: 'category'
        types: ['CodeableConcept']
        valueSets: () -> [ObservationCategoryCodesValueSet.JSON]
        isArray: true
      },
      {
        path: 'effective'
        types: ['DateTime', 'Period', 'Timing', 'Instant']
      },
      {
        path: 'component'
# TODO: Can be created with a composite view widget, autogenerated based in fields introspection.
        types: ['ObservationComponent']
        valueSets: () -> []
        isArray: true
      },
      {
        path: 'encounter'
        types: ['Reference']
        referenceTypes: ['Encounter']
      },
    ]
    Specimen: []
    CarePlan: []
    CareTeam: []
    Goal: []
    NutritionOrder: []
    ServiceRequest: [
      {
        path: 'intent'
        types: ['Code']
        valueSets: () -> [FhirValueSets.REQUEST_INTENT]
      },
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [FhirValueSets.REQUEST_STATUS]
      },
      {
        path: 'reasonCode'
        isArray: true
        types: ['CodeableConcept']
        valueSets: () -> [ProcedureReasonCodeValueSet.JSON]
      },
      {
        path: 'doNotPerform',
        types: ['Boolean']
      }
    ]
    Claim: []
    Communication: [
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [EventStatusValueSet.JSON]
      },
      {
        path: 'statusReason'
        types: ['CodeableConcept']
        valueSets: () -> [
          NegationReasonValueSet.MEDICAL_REASON_NOT_DONE,
          NegationReasonValueSet.PATIENT_REASON_NOT_DONE,
          NegationReasonValueSet.SYSTEM_REASONS
        ]
      }
    ]
    CommunicationRequest: []
    DeviceRequest: [
      {
        path: 'code'
        types: ['CodeableConcept', 'Reference']
        referenceTypes: ['Device']
        valueSets: () -> [DeviceKindValueSet.JSON]
      },
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [FhirValueSets.REQUEST_STATUS]
      },
      {
        path: 'intent'
        types: ['Code']
        valueSets: () -> [FhirValueSets.REQUEST_INTENT]
      }
    ]
    DeviceUseStatement: [
      {
        path: 'timing',
        types: ['DateTime', 'Period', 'Timing']
      }
    ]
    Location: []
    Device: []
    Substance: []
    Encounter: [
      {
        path: 'identifier'
        types: ['Identifier']
        isArray: true
      },
      {
        path: 'class'
        types: ['Coding']
        valueSets: () -> [FhirValueSets.ACT_ENCOUNTER_CODE_VS]
      },
      {
        path: 'diagnosis'
        types: ['EncounterDiagnosis']
        isArray: true
      },
      {
        path: 'length'
        types: ['Duration']
      },
      {
        path: 'location'
        types: ['EncounterLocation']
        isArray: true
      },
      {
        path: 'status'
        types: ['Code']
        valueSets: () ->
          FhirValueSets.ENCOUNTER_STATUS_VS
      },
      {
        path: 'hospitalization.admitSource',
        getValue: (fhirResource) -> fhirResource?.hospitalization?.admitSource
        setValue: (fhirResource, codeableConcept) ->
          if !fhirResource.hospitalization
            hospitalization = new cqm.models.EncounterHospitalization()
            fhirResource.hospitalization = hospitalization
          fhirResource.hospitalization.admitSource = codeableConcept
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.ENCOUNTER_ADMIT_SOURCE_VS]
      },
      {
        path: 'hospitalization.dischargeDisposition',
        getValue: (fhirResource) ->
          return fhirResource?.hospitalization?.dischargeDisposition
        setValue: (fhirResource, codeableConcept) ->
# EncounterHospitalization
          if !fhirResource.hospitalization
            hospitalization = new cqm.models.EncounterHospitalization()
            fhirResource.hospitalization = hospitalization
          fhirResource.hospitalization.dischargeDisposition = codeableConcept
        types: [
          'CodeableConcept'
        ]
        valueSets: () ->
          FhirValueSets.DISCHARGE_DISPOSITION_VS
      },
      {
        path: 'reasonCode'
        isArray: true
        types: ['CodeableConcept']
        valueSets: () -> [EncounterReasonCodeValueSet.JSON]
      },
    ]
    Flag: []
    Immunization: [
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [ImmunizationStatusValueSet.JSON]
      },
      {
        path: 'occurrence'
        types: ['DateTime']
      },
      {
        path: 'statusReason'
        types: ['CodeableConcept'],
        valueSets: () -> [
          ImmunizationStatusReasonValueSet.JSON
          NegationReasonValueSet.MEDICAL_REASON_NOT_DONE,
          NegationReasonValueSet.PATIENT_REASON_NOT_DONE,
          NegationReasonValueSet.SYSTEM_REASONS
        ]
      }
    ]
    ImmunizationEvaluation: []
    ImmunizationRecommendation: []
    Medication: []
    MedicationAdministration: [
      {
        path: 'dosage.route',
        getValue: (fhirResource) ->
          return fhirResource?.dosage?.route
        setValue: (fhirResource, codeableConcept) ->
          if !fhirResource.MedicationAdministrationDosage
            fhirResource.dosage = new cqm.models.MedicationAdministrationDosage()
          fhirResource.dosage.route = codeableConcept
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.ROUTE_CODES_VS]
      },
#      {
#        path: 'dosage.rate',
#        getValue: (fhirResource) ->
#          return fhirResource?.dosage?.rate
#        setValue: (fhirResource, value) ->
#          if !fhirResource.MedicationAdministrationDosage
#            fhirResource.dosage = new cqm.models.MedicationAdministrationDosage()
#          if !value?
#            fhirResource.dosage.rate = null
#          else
#            fhirResource.dosage.rate = value
#        types: ['Ratio']
#      },
      {
        path: 'medication'
        types: ['CodeableConcept', 'Reference']
        referenceTypes: ['Medication']
        valueSets: () -> [USCoreMedicationCodesValueSet.JSON]
      },
      {
        path: 'reasonCode'
        isArray: true
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.REASON_MEDICATION_GIVEN_VS]
      },
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [FhirValueSets.MEDICATION_ADMIN_STATUS_VS]
      },
      {
        path: 'statusReason'
        isArray: true
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.REASON_MEDICATION_NOT_GIVEN_VS]
      },
      {
        path: 'effective'
        types: ['DateTime', 'Period']
      }
    ]
    MedicationDispense: [
      {
        path: 'medication'
        types: ['CodeableConcept', 'Reference']
        referenceTypes: ['Medication']
        valueSets: () -> [USCoreMedicationCodesValueSet.JSON]
      },
      {
        path: 'dosageInstruction'
        getValue: (fhirResource) -> fhirResource?.dosageInstruction?[0]
        setValue: (fhirResource, value) -> fhirResource.dosageInstruction = if value? then [value] else null
        types: ['Dosage']
      },
      {
        path: 'dosageInstruction.timing'
        getValue: (fhirResource) -> fhirResource?.dosageInstruction?[0]?.timing
        setValue: (fhirResource, timing) ->
          if !timing?
            fhirResource?.dosageInstruction?[0]?.timing = null
          else
            fhirResource.dosageInstruction = [new cqm.models.Dosage()] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].timing = timing
        types: ['Timing']
      },
      {
        path: 'daysSupply',
        getValue: (fhirResource) -> fhirResource?.daysSupply
        setValue: (fhirResource, daysSupply) ->
          if !daysSupply?
            fhirResource?.daysSupply = null
          else
            fhirResource?.daysSupply = daysSupply
        types: ['SimpleQuantity']
      },
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [MedicationDispenseStatusValueSet.JSON]
      },
      {
        path: 'statusReason'
        types: ['CodeableConcept']
        valueSets: () -> [NegationReasonValueSet.MEDICAL_REASON_NOT_DONE, 
                          NegationReasonValueSet.PATIENT_REASON_NOT_DONE, 
                          NegationReasonValueSet.SYSTEM_REASONS]
      }
    ]
    MedicationRequest: [
      {
        path: 'doNotPerform'
        types: ['Boolean']
      },
      {
        path: 'medication'
        types: ['CodeableConcept', 'Reference']
        referenceTypes: ['Medication']
        valueSets: () -> [USCoreMedicationCodesValueSet.JSON]
      },
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_STATUS_VS]
      },
      {
        path: 'intent'
        types: ['Code']
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_INTENT_VS]
      },
      {
        path: 'category'
        isArray: true
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_CATEGORY_VS]
      },
      {
        path: 'dispenseRequest.validityPeriod'
        getValue: (fhirResource) -> fhirResource?.dispenseRequest?.validityPeriod
        setValue: (fhirResource, period) ->
          if !period?
            fhirResource?.dispenseRequest?.validityPeriod = null
          else
            fhirResource.dispenseRequest = new cqm.models.MedicationRequestDispenseRequest() unless fhirResource?.dispenseRequest
            fhirResource.dispenseRequest.validityPeriod = period
        types: ['Period']
      },
      {
        path: 'dosageInstruction.timing'
        title: 'dosageInstruction.timing'
        getValue: (fhirResource) -> fhirResource?.dosageInstruction?[0]?.timing
        setValue: (fhirResource, timing) ->
          if !timing?
            fhirResource?.dosageInstruction?[0]?.timing = null
          else
            fhirResource.dosageInstruction = [new cqm.models.Dosage()] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].timing = timing
        types: ['Timing']
      },
      {
        path: 'dosageInstruction.doseAndRate.rate'
        getValue: (fhirResource) ->
          if  cqm.models.SimpleQuantity.isSimpleQuantity(fhirResource?.dosageInstruction?[0]?.doseAndRate?[0]?.rate)
# Widget supports only Quantity:  convert SimpleQuantity -> Quantity
            return cqm.models.Quantity.parse(fhirResource?.dosageInstruction?[0]?.doseAndRate?[0]?.rate.toJSON())
          else
            return fhirResource?.dosageInstruction?[0]?.doseAndRate?[0]?.rate
        setValue: (fhirResource, rate) ->
          if !rate?
            fhirResource?.dosageInstruction?[0]?.doseAndRate?[0]?.rate = null
          else
            fhirResource.dosageInstruction = [new cqm.models.Dosage()] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].doseAndRate = [new cqm.models.DosageDoseAndRate()] unless fhirResource?.dosageInstruction?[0]?.doseAndRate
            if cqm.models.Quantity.isQuantity(rate)
# Widget supports only Quantity: convert Quantity -> SimpleQuantity
              fhirResource.dosageInstruction[0].doseAndRate[0].rate = cqm.models.SimpleQuantity.parse(rate.toJSON())
            else
              fhirResource.dosageInstruction[0].doseAndRate[0].rate = rate
        types: ['Ratio', 'Range', 'SimpleQuantity']
      },
      {
        path: 'reasonCode'
        isArray: true
        types: ['CodeableConcept']
        valueSets: () -> [
          ConditionCodesValueSet.JSON,
          NegationReasonValueSet.MEDICAL_REASON_NOT_DONE,
          NegationReasonValueSet.PATIENT_REASON_NOT_DONE,
          NegationReasonValueSet.SYSTEM_REASONS
        ]
      },
      {
        path: 'statusReason'
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_STATUS_REASON_VS]
        types: ['CodeableConcept']
      }
    ]
    MedicationStatement: [
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [FhirValueSets.MEDICATION_STATEMENT_STATUS_VS]
      }
    ]
    Patient: []
    Practitioner: []
    PractitionerRole: []
    RelatedPerson: []
    Task: [
      {
        path: 'basedOn'
        types: ['Reference']
        isArray: true
# referenceTypes placeholder, will be updated
        referenceTypes: ['Placeholder'],
        postInit: (taskBasedOn, task, dataElements) ->
          taskBasedOn.referenceTypes = Object.keys(dataElements)
      },
      {
        path: 'status'
        types: ['Code']
        valueSets: () -> [TaskStatusValueSet.JSON]
      },
      {
        path: 'reasonCode'
        types: ['CodeableConcept']
      }
    ]

# Dynamic initialization
  @postInitDataElements: (dataElements) ->
    for dataElement in Object.values(dataElements)
      for attrDef in Object.values(dataElement)
        attrDef.postInit?(attrDef, dataElement, dataElements)
        setValue = attrDef.setValue
        getValue = attrDef.getValue
        unless setValue?
          setValue = (fhirResource, value) ->
            fhirResource[this.path] = value
        unless getValue?
          getValue = (fhirResource) ->
            fhirResource[this.path]
        attrDef.setValue = _.bind(setValue, attrDef)
        attrDef.getValue = _.bind(getValue, attrDef)

  @postInitDataElements(@DATA_ELEMENT_ATTRIBUTES)

  # Additional metadata for composite types, not captured in ModelInfo/ Models.
  # 1st level entries - list of supported types for CompositeView editor
  # 2nd level entries - are supported properties with custom metadata
  @COMPOSITE_TYPES:
    EncounterLocation:
      location:
        referenceTypes: ['Location']
        types: ['Reference']
      period:
        types: ['Period']
    EncounterDiagnosis:
      condition:
        referenceTypes: ['Condition', 'Procedure']
        types: ['Reference']
      rank:
        types: ['PositiveInt']
      use:
        types: ['CodeableConcept']
        valueSets: () -> [DiagnosisRoleValueSet.JSON]

  @isCompositeType: (typeName) ->
    @COMPOSITE_TYPES.hasOwnProperty(typeName)

  @getCompositeAttributes: (compositeTypeName) ->
    attributes = []
    compositeType = @COMPOSITE_TYPES[compositeTypeName]
    for path in Object.keys(compositeType).sort()
      attributes.push(@getCompositeAttribute(compositeTypeName, path))
    attributes

  @getCompositeAttribute: (compositeTypeName, path) ->
    compositeType = @COMPOSITE_TYPES[compositeTypeName]
    {
      path: path
      types: compositeType[path].types
      valueSets: compositeType[path].valueSets
      referenceTypes: compositeType[path].referenceTypes
    }
