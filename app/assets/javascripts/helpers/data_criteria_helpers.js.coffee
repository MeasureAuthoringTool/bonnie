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

  @createIntervalFromPeriod: (period) ->
    return null if period == undefined ||
      (period?.start == undefined && period?.end == undefined)

    startDate = @getCQLDateTimeFromString(period?.start?.value) if period?.start?.value?
    endDate = @getCQLDateTimeFromString(period?.end?.value) if period?.end?.value?
    new cqm.models.CQL.Interval(startDate, endDate)

  @getCQLDateTimeFromString: (dateStr) ->
    return null if dateStr == undefined
    cqm.models.CQL.DateTime.fromJSDate(new Date(dateStr), 0)

  @getCQLDateFromString: (dateStr) ->
    return null if dateStr == undefined
    date = moment(dateStr, 'YYYY-MM-DD').toDate()
    cqm.models.CQL.Date.fromJSDate(date)

  @createPeriodFromInterval: (interval) ->
    period = new cqm.models.Period()
    period.start = period.end = null
    period.start = cqm.models.PrimitiveDateTime.parsePrimitive interval.low.toString() if interval && interval.low?
    period.end = cqm.models.PrimitiveDateTime.parsePrimitive interval.high.toString() if interval && interval.high?
    return period

  @getPeriodForStringDateTime: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDateTime = @getCQLDateTimeFromString(dateTimeStr)
    interval = new cqm.models.CQL.Interval(cqlDateTime, cqlDateTime.add(15, cqm.models.CQL.DateTime.Unit.MINUTE))
    @createPeriodFromInterval(interval)

  @getPeriodForStringDate: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDateTime = @getCQLDateTimeFromString(dateTimeStr).add(8, cqm.models.CQL.DateTime.Unit.HOUR)
    interval = new cqm.models.CQL.Interval(cqlDateTime, cqlDateTime.add(15, cqm.models.CQL.DateTime.Unit.MINUTE))
    @createPeriodFromInterval(interval)

  @getPrimitiveDateTimeForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveDateTime.parsePrimitive dateTime?.toString()

  @getPrimitiveInstantForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveInstant.parsePrimitive dateTime?.toString()

  @getPrimitiveDateTimeForStringDateTime: (dateTimeStr) ->
    cqm.models.PrimitiveDateTime.parsePrimitive dateTimeStr

  @getPrimitiveDateTimeForStringDate: (dateStr) ->
    return null unless dateStr?
    cqlDateTime = @getCQLDateTimeFromString(dateStr).add(8, cqm.models.CQL.DateTime.Unit.HOUR)
    cqm.models.PrimitiveDateTime.parsePrimitive cqlDateTime.toString()

  @getPrimitiveInstantForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveInstant.parsePrimitive dateTime?.toString()

  @getPrimitiveDateForCqlDate: (date) ->
    cqm.models.PrimitiveDate.parsePrimitive date?.toString()

  @getPrimitiveDateForStringDateTime: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDate = @getCQLDateFromString(dateTimeStr)
    cqm.models.PrimitiveDate.parsePrimitive cqlDate.toString()

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
    attributes = @DATA_ELEMENT_ATTRIBUTES[resourceType]?.sort( (a, b) -> a.path.localeCompare(b.path) )
    return attributes || []

  @getAttribute: (dataElement, path) ->
    resourceType = dataElement.fhir_resource?.resourceType
    return @DATA_ELEMENT_ATTRIBUTES[resourceType]?.find((attr) => attr.path is path)

  @getCodeableConceptForCoding: (coding) ->
    return null unless coding?
    codeableConcept = new cqm.models.CodeableConcept()
    codeableConcept.coding = [coding]
    codeableConcept

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

    if cqm.models.PrimitiveDateTime.isPrimitiveDateTime(type)  || cqm.models.PrimitiveInstant.isPrimitiveInstant(type)
      cqlValue = DataCriteriaHelpers.getCQLDateTimeFromString(type?.value)
      return moment.utc(cqlValue.toJSDate()).format('L LT')

    if cqm.models.PrimitiveDate.isPrimitiveDate(type)
      cqlValue = DataCriteriaHelpers.getCQLDateFromString(type?.value)
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
      return "[" + type.coding.map( (coding) => "#{@stringifyType(coding, codeSystemMap)}" ).join(', ') + "]"

    if cqm.models.Timing.isTiming(type)
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
    if cqm.models.Dosage.isDosage(type)
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

    if cqm.models.Identifier.isIdentifier(type)
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

    return JSON.stringify(type)

# Data element attributes per resource type.
# Each resource has an array of entries per attribute.
# An attribute entry has necessary metadata to view/edit.
#   path - attribute/element path, relative to the current resource
#   title - an element name show to the User, same as path for now
#   getValue(fhirResource) - getter accessor which returns a FHIR value for the attribute,
#      shall be compatible with an UI element
#   setValue(fhirResource, value) - setter accessor which updates the resource with a value from UI.
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
        title: 'clinicalStatus'
        getValue: (fhirResource) -> fhirResource?.clinicalStatus?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource.clinicalStatus = @getCodeableConceptForCoding(coding)
        types: [
          'CodeableConcept'
        ]
        valueSets: () -> [FhirValueSets.ALLERGYINTOLERANCE_CLINICAL_VS]
      },
      {
        path: 'onset'
        title: 'onset'
        getValue: (fhirResource) -> fhirResource?.onset
        setValue: (fhirResource, value) ->
          fhirResource.onset = value
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'verificationStatus',
        title: 'verificationStatus',
        getValue: (fhirResource) -> fhirResource?.verificationStatus?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource.verificationStatus = @getCodeableConceptForCoding(coding)
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.ALLERGYINTOLERANCE_VERIFICATION_VS]
      }
    ]
    Condition: [
      {
        path: 'clinicalStatus'
        title: 'clinicalStatus'
        getValue: (fhirResource) -> fhirResource?.clinicalStatus?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource.clinicalStatus = @getCodeableConceptForCoding(coding)
        types: [
          'CodeableConcept'
        ]
        valueSets: () -> [FhirValueSets.CONDITION_CLINICAL_VS]
      },
      {
        path: 'verificationStatus',
        title: 'verificationStatus',
        getValue: (fhirResource) -> fhirResource?.verificationStatus?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource.verificationStatus = @getCodeableConceptForCoding(coding)
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.CONDITION_VER_STATUS_VS]
      },
      {
        path: 'onset'
        title: 'onset'
        getValue: (fhirResource) -> fhirResource?.onset
        setValue: (fhirResource, value) ->
          fhirResource.onset = value
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'abatement',
        title: 'abatement',
        getValue: (fhirResource) -> fhirResource?.abatement
        setValue: (fhirResource, value) =>
          fhirResource.abatement = value
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'bodySite',
        title: 'bodySite',
        getValue: (fhirResource) -> fhirResource?.bodySite?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.bodySite = if codeableConcept? then [codeableConcept] else codeableConcept
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [BodySiteValueSet.JSON]
      },
      {
        path: 'category',
        title: 'category',
        getValue: (fhirResource) -> fhirResource?.category?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.category = if codeableConcept? then [codeableConcept] else codeableConcept
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.CONDITION_CATEGORY_VS]
      },
      {
        path: 'severity'
        title: 'severity'
        getValue: (fhirResource) -> fhirResource?.severity?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource.severity = @getCodeableConceptForCoding(coding)
        types: [
          'CodeableConcept'
        ]
        valueSets: () -> [ConditionSeverityValueSet.JSON]
      },
      {
        path: 'recorder'
        title: 'recorder'
        getValue: (fhirResource) -> fhirResource.recorder
        setValue: (fhirResource, reference) ->
          fhirResource.recorder = reference
        types: ['Reference']
        referenceTypes: ['Practitioner', 'PractitionerRole', 'RelatedPerson']
      },
      {
        path: 'asserter'
        title: 'asserter'
        getValue: (fhirResource) -> fhirResource.asserter
        setValue: (fhirResource, reference) ->
          fhirResource.asserter = reference
        types: ['Reference']
        referenceTypes: ['Practitioner', 'PractitionerRole', 'RelatedPerson']
      }
    ]
    FamilyMemberHistory: []
    Procedure: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) ->
          if codeValue?
            fhirResource?.status = cqm.models.ProcedureStatus.parsePrimitive(codeValue)
          else
            fhirResource?.status = null
        types: ['Code']
        valueSets: () -> [FhirValueSets.EVENT_STATUS_VS]
      },
      {
        path: 'performed',
        title: 'performed',
        getValue: (fhirResource) -> fhirResource?.performed
        setValue: (fhirResource, value) =>
          fhirResource.performed = value
        types: ['DateTime', 'Period']
      },
      {
        path: 'category',
        title: 'category',
        getValue: (fhirResource) -> fhirResource?.category?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource.category = @getCodeableConceptForCoding(coding)
        types: ['CodeableConcept'],
        valueSets: () -> [FhirValueSets.PROCEDURE_CATEGORY_VS]
      },
      {
        path: 'statusReason',
        title: 'statusReason',
        getValue: (fhirResource) -> fhirResource?.statusReason?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource.statusReason = @getCodeableConceptForCoding(coding)
        types: ['CodeableConcept'],
        valueSets: () -> [FhirValueSets.PROCEDURE_NOT_PERFORMED_REASON_VS]
      },
      {
        path: 'reasonCode',
        title: 'reasonCode',
        getValue: (fhirResource) -> fhirResource?.reasonCode?[0].coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.reasonCode = if codeableConcept? then [codeableConcept] else codeableConcept
        types: ['CodeableConcept'],
        valueSets: () -> [ProcedureReasonValueSet.JSON]
      },
      {
        path: 'usedCode',
        title: 'usedCode',
        getValue: (fhirResource) -> fhirResource?.usedCode?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.usedCode = if codeableConcept? then [codeableConcept] else codeableConcept
        types: ['CodeableConcept'],
        valueSets: () -> [DeviceKindValueSet.JSON]
      }
    ]
    Coverage: []
    BodyStructure: []
    DiagnosticReport: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if (codeValue)
            fhirResource?.status = cqm.models.DiagnosticReportStatus.parsePrimitive(codeValue)
          else
            fhirResource?.status = null
        types: ['Code']
        valueSets: () -> [DiagnosticReportStatusValueSet.JSON]
      },
      {
        path: 'effective',
        title: 'effective',
        getValue: (fhirResource) -> fhirResource.effective
        setValue: (fhirResource, value) ->
          fhirResource.effective = value
        types: ['DateTime', 'Period']
      },
      {
        path: 'encounter'
        title: 'encounter'
        getValue: (fhirResource) -> fhirResource.encounter
        setValue: (fhirResource, reference) ->
          fhirResource.encounter = reference
        types: ['Reference']
        referenceTypes: ['Encounter']
      },
      {
        path: 'category',
        title: 'category',
        getValue: (fhirResource) -> fhirResource.category?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.category = if codeableConcept? then [codeableConcept] else codeableConcept
        types: ['CodeableConcept'],
# Value Set from FHIR and QI Core DiagnosticReport Lab  http://hl7.org/fhir/ValueSet/diagnostic-service-sections
# Value Set from QI Core DiagnosticReport Note (http://hl7.org/fhir/us/qicore/StructureDefinition-qicore-diagnosticreport-note.html)
#     http://hl7.org/fhir/us/core/ValueSet/us-core-diagnosticreport-category
        valueSets: () -> [ DiagnosticServiceSectionCodesValueSet.JSON, USCoreDiagnosticReportCategoryValueSet.JSON ]
      }
    ]
    ImagingStudy: []
    Observation: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if (codeValue)
            fhirResource.status = cqm.models.ObservationStatus.parsePrimitive(codeValue)
          else
            fhirResource.status = null
        types: ['Code']
        valueSets: () -> [ObservationStatusValueSet.JSON]
      },
      {
        path: 'value'
        title: 'value'
        getValue: (fhirResource) ->
          if  cqm.models.CodeableConcept.isCodeableConcept(fhirResource?.value)
            return fhirResource.value.coding?[0]
          else
            fhirResource?.value
        setValue: (fhirResource, value) =>
          attrType = value?.getTypeName?() || value?.constructor?.name
          if attrType == 'Coding'
            fhirResource.value = @getCodeableConceptForCoding(value)
          else
            fhirResource?.value = value
        types: ['Boolean', 'CodeableConcept', 'DateTime', 'Integer', 'Period',
          'Quantity', 'Range', 'Ratio', 'SampledData', 'String', 'Time'],
        valueSets: () -> []
      },
      {
        path: 'category',
        title: 'category',
        getValue: (fhirResource) -> fhirResource.category?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.category = if codeableConcept? then [codeableConcept] else codeableConcept
        types: ['CodeableConcept'],
        valueSets: () -> [ObservationCategoryCodesValueSet.JSON]
      },
      {
        path: 'effective',
        title: 'effective',
        getValue: (fhirResource) -> fhirResource.effective
        setValue: (fhirResource, value) ->
          fhirResource.effective = value
        types: ['DateTime', 'Period', 'Timing', 'Instant']
      },
      {
        path: 'component.code',
        title: 'component.code',
        getValue: (fhirResource) -> fhirResource.component?[0]?.code?.coding?[0]
        setValue: (fhirResource, coding) =>
          unless fhirResource.component?
            fhirResource.component = [new cqm.models.ObservationComponent()]
          fhirResource.component[0].code = @getCodeableConceptForCoding(coding)
        types: ['CodeableConcept'],
        valueSets: () -> [LOINCCodesValueSet.JSON]
      },
      {
        path: 'component.value',
        title: 'component.value',
        getValue: (fhirResource) ->
          if  cqm.models.CodeableConcept.isCodeableConcept(fhirResource.component?[0]?.value)
            fhirResource.component[0].value.coding?[0]
          else
            fhirResource.component?[0]?.value
        setValue: (fhirResource, value) =>
          attrType = value?.getTypeName?() || value?.constructor?.name
          unless fhirResource.component?
            fhirResource.component = [new cqm.models.ObservationComponent()]
          if attrType == 'Coding'
            fhirResource.component[0].value = @getCodeableConceptForCoding(value)
          else
            fhirResource.component[0].value = value
        types: ['Quantity', 'CodeableConcept', 'String', 'Boolean', 'Integer',
          'Range', 'Ratio', 'SampledData','Time', 'DateTime', 'Period'],
        valueSets: () -> []
      },
      {
        path: 'encounter'
        title: 'encounter'
        getValue: (fhirResource) -> fhirResource.encounter
        setValue: (fhirResource, reference) ->
          fhirResource.encounter = reference
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
        title: 'intent'
        getValue: (fhirResource) -> fhirResource?.intent?.value
        setValue: (fhirResource, codeValue) =>
          if (codeValue)
            fhirResource?.intent = cqm.models.ServiceRequestIntent.parsePrimitive(codeValue)
          else
            fhirResource?.intent = null
        types: ['Code']
        valueSets: () -> [FhirValueSets.REQUEST_INTENT]
      },
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if (codeValue)
            fhirResource?.status = cqm.models.ServiceRequestStatus.parsePrimitive(codeValue)
          else
            fhirResource?.status = null
        types: ['Code']
        valueSets: () -> [FhirValueSets.REQUEST_STATUS]
      },
      {
        path: 'reasonCode'
        title: 'reasonCode'
        getValue: (fhirResource) => fhirResource?.reasonCode?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.reasonCode = if codeableConcept? then [codeableConcept] else codeableConcept
        valueSets: () -> [window.ProcedureReasonCodeValueSet.JSON]
        types: ['CodeableConcept']
      },
      {
        path: 'id'
        title: 'id'
        getValue: (fhirResource) => fhirResource?.id
        setValue: (fhirResource, value) =>
          fhirResource.id = value
        types: ['String']
      },
    ]
    Claim: []
    Communication: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) => fhirResource?.status?.value
        setValue: (fhirResource, codeValue) ->
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = codeValue;
        types: ['Code']
        valueSets: () => [EventStatusValueSet.JSON]
      }
    ]
    CommunicationRequest: []
    DeviceRequest: []
    DeviceUseStatement: [
      {
        path: 'timing',
        title: 'timing',
        getValue: (fhirResource) -> fhirResource.timing
        setValue: (fhirResource, value) =>
          fhirResource.timing = value
        types: ['DateTime', 'Period', 'Timing']
      }
    ]
    Location: []
    Device: []
    Substance: []
    Encounter: [
      {
        path: 'identifier'
        title: 'identifier'
        getValue: (fhirResource) -> fhirResource?.identifier?[0]
        setValue: (fhirResource, value) -> fhirResource.identifier = if value? then [value] else  null
        types: ['Identifier']
      },
      {
        path: 'class'
        title: 'class'
        getValue: (fhirResource) -> fhirResource?['class']
        setValue: (fhirResource, coding) ->
          if !coding?
            fhirResource?['class'] = null
          else
            fhirResource?['class'] = coding
        types: ['Coding']
        valueSets: () -> [FhirValueSets.ACT_ENCOUNTER_CODE_VS]
      },
      {
        path: 'diagnosis.condition'
        title: 'diagnosis.condition'
        getValue: (fhirResource) -> fhirResource?['diagnosis']?[0]?.condition
        setValue: (fhirResource, reference) =>
          fhirResource?['diagnosis'] = [ new cqm.models.EncounterDiagnosis() ] unless fhirResource?['diagnosis']?
          fhirResource?['diagnosis'][0]?.condition = reference
        types: ['Reference']
# Reference can be a part of Choice type, so we keep referenceTypes[] separate from types[]
# Reference a Condition or a Procedure resource
        referenceTypes: ['Condition', 'Procedure']
      },
      {
        path: 'diagnosis.use'
        title: 'diagnosis.use'
        getValue: (fhirResource) -> fhirResource?['diagnosis']?[0]?.use?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource?['diagnosis'] = [ new cqm.models.EncounterDiagnosis() ] unless fhirResource?['diagnosis']?
          fhirResource.diagnosis[0]?.use = @getCodeableConceptForCoding(coding)
        types: ['CodeableConcept']
        valueSets: () -> [DiagnosisRoleValueSet.JSON]
      },
      {
        path: 'diagnosis.rank'
        title: 'diagnosis.rank'
        getValue: (fhirResource) -> fhirResource?['diagnosis']?[0]?.rank
        setValue: (fhirResource, value) =>
          fhirResource?['diagnosis'] = [ new cqm.models.EncounterDiagnosis() ] unless fhirResource?['diagnosis']?
          fhirResource['diagnosis'][0]?.rank = value
        types: ['PositiveInt']
      },
      {
        path: 'length'
        title: 'length'
        getValue: (fhirResource) ->
          fhirResource?.length
        setValue: (fhirResource, value) =>
          fhirResource?.length = value
        types: ['Duration']
      },
      {
        path: 'location.period'
        title: 'location.period'
        getValue: (fhirResource) ->
          fhirResource?.location?[0]?.period
        setValue: (fhirResource, value) =>
          if !fhirResource.location
            encounterLocation = new cqm.models.EncounterLocation()
            fhirResource.location = [encounterLocation]
          fhirResource.location[0].period = value
        types: ['Period']
      },
      {
        path: 'location.location'
        title: 'location.location'
        getValue: (fhirResource) -> fhirResource?['location']?[0]?.location
        setValue: (fhirResource, reference) ->
          fhirResource?['location'] = [ new cqm.models.EncounterLocation() ] unless fhirResource?['location']?
          fhirResource?['location'][0]?.location = reference
        types: ['Reference']
# Reference can be a part of Choice type, so we keep referenceTypes[] separate from types[]
# Reference a Condition or a Procedure resource
        referenceTypes: ['Location']
      },
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) ->
          return fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.EncounterStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () ->
          FhirValueSets.ENCOUNTER_STATUS_VS
      },
      {
        path: 'hospitalization.admitSource',
        title: 'hospitalization.admitSource',
        getValue: (fhirResource) -> fhirResource?.hospitalization?.admitSource?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !fhirResource.hospitalization
            hospitalization = new cqm.models.EncounterHospitalization()
            fhirResource.hospitalization = hospitalization
          fhirResource.hospitalization.admitSource = @getCodeableConceptForCoding(coding)
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.ENCOUNTER_ADMIT_SOURCE_VS]
      },
      {
        path: 'hospitalization.dischargeDisposition',
        title: 'hospitalization.dischargeDisposition',
        getValue: (fhirResource) ->
          return fhirResource?.hospitalization?.dischargeDisposition?.coding?[0]
        setValue: (fhirResource, coding) =>
# EncounterHospitalization
          if !fhirResource.hospitalization
            hospitalization = new cqm.models.EncounterHospitalization()
            fhirResource.hospitalization = hospitalization
          fhirResource.hospitalization.dischargeDisposition = @getCodeableConceptForCoding(coding)
        types: [
          'CodeableConcept' # User will see 'CodeableConcept', but it works with Coding behind the scenes
        ]
        valueSets: () ->
          FhirValueSets.DISCHARGE_DISPOSITION_VS
      },
      {
        path: 'reasonCode'
        title: 'reasonCode'
        getValue: (fhirResource) => fhirResource?.reasonCode?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.reasonCode = if codeableConcept? then [codeableConcept] else codeableConcept
        valueSets: () -> [window.EncounterReasonCodeValueSet.JSON]
        types: ['CodeableConcept']
      },
    ]
    Flag: []
    Immunization: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if (codeValue)
            fhirResource?.status = cqm.models.ImmunizationStatus.parsePrimitive(codeValue)
          else
            fhirResource?.status = null
        types: ['Code']
        valueSets: () -> [ ImmunizationStatusValueSet.JSON ]
      },
      {
        path: 'occurrence'
        title: 'occurrence'
        getValue: (fhirResource) -> fhirResource?.occurrence
        setValue: (fhirResource, occurrence) ->
          fhirResource?.occurrence = occurrence
        types: ['DateTime']
      }
    ]
    ImmunizationEvaluation: []
    ImmunizationRecommendation: []
    Medication: []
    MedicationAdministration: [
      {
        path: 'dosage.route',
        title: 'dosage.route',
        getValue: (fhirResource) ->
          return fhirResource?.dosage?.route?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !fhirResource.MedicationAdministrationDosage
            fhirResource.dosage = new cqm.models.MedicationAdministrationDosage()
          fhirResource.dosage.route = @getCodeableConceptForCoding(coding)
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.ROUTE_CODES_VS]
      },
#      {
#        path: 'dosage.rate',
#        title: 'dosage.rate',
#        getValue: (fhirResource) ->
#          return fhirResource?.dosage?.rate
#        setValue: (fhirResource, value) =>
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
        title: 'medication'
        getValue: (fhirResource) ->
          if !fhirResource?.medication?
            return null
          if cqm.models.CodeableConcept.isCodeableConcept(fhirResource?.medication)
            return fhirResource.medication.coding?[0]
          else
            fhirResource?.medication
        setValue: (fhirResource, value) =>
          if cqm.models.Coding.isCoding(value)
            codeableConcept = @getCodeableConceptForCoding(value)
            fhirResource.medication = codeableConcept
          else if cqm.models.Reference.isReference(value)
            fhirResource.medication = value
          else
            fhirResource.medication = null
        types: ['CodeableConcept', 'Reference']
        referenceTypes: ['Medication']
        valueSets: () -> [USCoreMedicationCodesValueSet.JSON]
      },
      {
        path: 'reasonCode',
        title: 'reasonCode',
        getValue: (fhirResource) -> fhirResource?.reasonCode?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.reasonCode = if codeableConcept? then [codeableConcept] else codeableConcept
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.REASON_MEDICATION_GIVEN_VS]
      },
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.MedicationAdministrationStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () -> [FhirValueSets.MEDICATION_ADMIN_STATUS_VS]
      },
      {
        path: 'statusReason'
        title: 'statusReason'
        getValue: (fhirResource) -> fhirResource?.statusReason?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.statusReason = if codeableConcept? then [codeableConcept] else codeableConcept
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.REASON_MEDICATION_NOT_GIVEN_VS]
      },
      {
        path: 'effective',
        title: 'effective',
        getValue: (fhirResource) -> fhirResource.effective
        setValue: (fhirResource, value) ->
          fhirResource.effective = value
        types: ['DateTime', 'Period']
      }
    ]
    MedicationDispense: [
      {
        path: 'medication'
        title: 'medication'
        getValue: (fhirResource) ->
          if !fhirResource?.medication?
            return null
          if cqm.models.CodeableConcept.isCodeableConcept(fhirResource?.medication)
            return fhirResource.medication.coding?[0]
          else
            fhirResource?.medication
        setValue: (fhirResource, value) =>
          if cqm.models.Coding.isCoding(value)
            codeableConcept = @getCodeableConceptForCoding(value)
            fhirResource.medication = codeableConcept
          else if cqm.models.Reference.isReference(value)
            fhirResource.medication = value
          else
            fhirResource.medication = null
        types: ['CodeableConcept', 'Reference']
        referenceTypes: ['Medication']
        valueSets: () -> [USCoreMedicationCodesValueSet.JSON]
      },
      {
        path: 'dosageInstruction'
        title: 'dosageInstruction'
        getValue: (fhirResource) -> fhirResource?.dosageInstruction?[0]
        setValue: (fhirResource, value) -> fhirResource.dosageInstruction = if value? then [value] else  null
        types: ['Dosage']
      },
      {
        path: 'dosageInstruction.timing'
        title: 'dosageInstruction.timing'
        getValue: (fhirResource) -> fhirResource?.dosageInstruction?[0]?.timing
        setValue: (fhirResource, timing) ->
          if !timing?
            fhirResource?.dosageInstruction?[0]?.timing = null
          else
            fhirResource.dosageInstruction = [ new cqm.models.Dosage() ] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].timing = timing
        types: ['Timing']
      },
      {
        path: 'daysSupply',
        title: 'daysSupply',
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
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.MedicationDispenseStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () -> [MedicationDispenseStatusValueSet.JSON]
      }
    ]
    MedicationRequest: [
# Not ready for delivery.
#      {
#        path: 'doNotPerform'
#        title: 'doNotPerform'
#        getValue: (fhirResource) -> fhirResource?.doNotPerform?.value
#        setValue: (fhirResource, primitiveBoolean) =>
#          if !primitiveBoolean?
#            fhirResource?.doNotPerform = null
#          else
#            fhirResource?.doNotPerform = primitiveBoolean
#        types: ['Boolean']
#      },
      {
        path: 'medication'
        title: 'medication'
        getValue: (fhirResource) ->
          if !fhirResource?.medication?
            return null
          if cqm.models.CodeableConcept.isCodeableConcept(fhirResource?.medication)
            return fhirResource.medication.coding?[0]
          else
            fhirResource?.medication
        setValue: (fhirResource, value) =>
          if cqm.models.Coding.isCoding(value)
            codeableConcept = @getCodeableConceptForCoding(value)
            fhirResource.medication = codeableConcept
          else if cqm.models.Reference.isReference(value)
            fhirResource.medication = value
          else
            fhirResource.medication = null
        types: ['CodeableConcept', 'Reference']
        referenceTypes: ['Medication']
        valueSets: () -> [USCoreMedicationCodesValueSet.JSON]
      },
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.MedicationRequestStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_STATUS_VS]
      },
      {
        path: 'intent'
        title: 'intent'
        getValue: (fhirResource) -> fhirResource?.intent?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.intent = null
          else
            fhirResource?.intent = cqm.models.MedicationRequestIntent.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_INTENT_VS]
      },
      {
        path: 'category'
        title: 'category'
        getValue: (fhirResource) -> fhirResource?.category?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.category = if codeableConcept? then [codeableConcept] else codeableConcept
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_CATEGORY_VS]
      },
      {
        path: 'dispenseRequest.validityPeriod'
        title: 'dispenseRequest.validityPeriod'
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
        path: 'dosageInstruction.doseAndRate.rate'
        title: 'dosageInstruction.doseAndRate.rate'
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
            fhirResource.dosageInstruction = [ new cqm.models.Dosage() ] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].doseAndRate = [ new cqm.models.DosageDoseAndRate() ] unless fhirResource?.dosageInstruction?[0]?.doseAndRate
            if cqm.models.Quantity.isQuantity(rate)
# Widget supports only Quantity: convert Quantity -> SimpleQuantity
              fhirResource.dosageInstruction[0].doseAndRate[0].rate = cqm.models.SimpleQuantity.parse(rate.toJSON())
            else
              fhirResource.dosageInstruction[0].doseAndRate[0].rate = rate
        types: ['Ratio', 'Range', 'SimpleQuantity']
      },
      {
        path: 'dosageInstruction.timing.code'
        title: 'dosageInstruction.timing.code'
        getValue: (fhirResource) -> fhirResource?.dosageInstruction?[0]?.timing?.code?.coding?[0]
        setValue: (fhirResource, coding) ->
          if !coding?
            fhirResource?.dosageInstruction?[0]?.timing?.code = null
          else
            fhirResource.dosageInstruction = [ new cqm.models.Dosage() ] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].timing = new cqm.models.Timing() unless fhirResource?.dosageInstruction?[0]?.timing
            fhirResource.dosageInstruction[0].timing.code = new cqm.models.CodeableConcept()
            fhirResource.dosageInstruction[0].timing.code.coding = [ coding ]

        valueSets: () ->
          [FhirValueSets.TIMING_ABBREVIATION_VS]
        types: ['CodeableConcept']
      },
      {
        path: 'dosageInstructions.timing.repeat.bounds'
        title: 'dosageInstructions.timing.repeat.bounds'
        getValue: (fhirResource) -> fhirResource?.dosageInstruction?[0]?.timing?.repeat?.bounds
        setValue: (fhirResource, bounds) ->
          if !bounds?
            fhirResource?.dosageInstruction?[0]?.timing?.repeat?.bounds = null
          else
            fhirResource.dosageInstruction = [ new cqm.models.Dosage() ] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].timing = new cqm.models.Timing() unless fhirResource?.dosageInstruction?[0]?.timing
            fhirResource.dosageInstruction[0].timing.repeat = new cqm.models.TimingRepeat() unless fhirResource?.dosageInstruction?[0]?.timing?.repeat
            fhirResource.dosageInstruction[0].timing.repeat.bounds = bounds
        types: ['Duration', 'Range', 'Period']
      },
      {
        path: 'reasonCode'
        title: 'reasonCode'
        getValue: (fhirResource) -> fhirResource?.reasonCode?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          codeableConcept = @getCodeableConceptForCoding(coding)
          fhirResource.reasonCode = if codeableConcept? then [codeableConcept] else codeableConcept
        valueSets: () -> [ConditionCodesValueSet.JSON]
        types: ['CodeableConcept']
      },
      {
        path: 'statusReason'
        title: 'statusReason'
        getValue: (fhirResource) -> fhirResource?.statusReason?.coding?[0]
        setValue: (fhirResource, coding) =>
          fhirResource?.statusReason = @getCodeableConceptForCoding(coding)
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_STATUS_REASON_VS]
        types: ['CodeableConcept']
      }
    ]
    MedicationStatement: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.MedicationStatementStatus.parsePrimitive(codeValue)
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
        title: 'basedOn'
        getValue: (fhirResource) -> fhirResource.basedOn?[0]
        setValue: (fhirResource, reference) ->
          if reference?
            fhirResource?.basedOn = [] unless fhirResource?.basedOn?
            fhirResource.basedOn[0] = reference
          else
            fhirResource.basedOn = null

        types: ['Reference']
        # referenceTypes placeholder, will be updarted
        referenceTypes: ['Placeholder'],
        postInit: (taskBasedOn, task, dataElements) ->
          taskBasedOn.referenceTypes = Object.keys(dataElements)
      },
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) -> fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.TaskStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () -> [TastStatusValueSet.JSON]
      }
    ]

  # Dynamic initialization
  @postInitDataElements: (dataElements) ->
    for dataElement in Object.values(dataElements)
      for attrDef in Object.values(dataElement)
        attrDef.postInit?(attrDef, dataElement, dataElements)

  @postInitDataElements(@DATA_ELEMENT_ATTRIBUTES)
