# View for negation
class Thorax.Views.CommunicationNegationView extends Thorax.Views.BonnieView
  template: JST['patient_builder/communication_negation']

  initialize: ->
    @status = new Thorax.Views.InputCodeView({
      initialValue: @resource.status?.value
      cqmValueSets: [FhirValueSets.EVENT_STATUS_VS],
      codeSystemMap: @codeSystemMap,
      name: 'status'})
    @statusReason = new Thorax.Views.InputCodingView({
      initialValue: @resource.statusReason?.coding?[0]
      cqmValueSets: [
        NegationReasonValueSet.MEDICAL_REASON_NOT_DONE,
        NegationReasonValueSet.PATIENT_REASON_NOT_DONE,
        NegationReasonValueSet.SYSTEM_REASONS].concat(@cqmValueSets),
      codeSystemMap: @codeSystemMap,
      name: 'status reason'})
    @recordedDateTime = new Thorax.Views.InputDateTimeView({
      initialValue: NegationHelpers.getRecordedDate(@resource)
      defaultYear: 2012,
      attributeTitle: 'recorded',
      name: 'recorded',
      attributeName: 'When this was made available',
      allowNull: false,
      showLabel: true
    })
    @reasonCode = new Thorax.Views.InputCodingView({
      initialValue: @resource.reasonCode?[0].coding?[0]
      cqmValueSets: [].concat(@cqmValueSets)
      codeSystemMap: @codeSystemMap
      name: 'reason code'
    })
    @listenTo(@status, 'valueChanged', () -> @performNegation(@status))
    @listenTo(@statusReason, 'valueChanged', () -> @performNegation(@statusReason))
    @listenTo(@recordedDateTime, 'valueChanged', () -> @performNegation(@recordedDateTime))
    @listenTo(@reasonCode, 'valueChanged', () -> @performNegation(@reasonCode))

  resetNegation: ->
    @recordedDateTime.reset()
    @status.resetCodeSelection()
    @statusReason.resetCodeSelection()
    @reasonCode.resetCodeSelection()
    @resource.modifierExtension = @resource.modifierExtension?.filter(
      (extension) -> extension.url?.value != NegationHelpers.QICORE_NOT_DONE_URL)

# mark neagation set to true
  setNegation: ->
    value = cqm.models.PrimitiveBoolean.parsePrimitive(true)
    if @resource.modifierExtension
      @resource.modifierExtension.push(
        NegationHelpers.createExtension(value, 'Boolean', NegationHelpers.QICORE_NOT_DONE_URL))
    else
      @resource.modifierExtension = [
        NegationHelpers.createExtension(value, 'Boolean', NegationHelpers.QICORE_NOT_DONE_URL) ]

  performNegation: (view) ->
    switch view.name
      when 'status'
        @resource.status = if view.value then cqm.models.CommunicationStatus.parsePrimitive(view.value) else undefined
      when 'status reason'
        @resource.statusReason = NegationHelpers.getCodeableConcept(view.value)
      when 'recorded'
        NegationHelpers.setRecordedExtention(view.value, @resource)
      when 'reason code'
        NegationHelpers.setResonCodeExtension(view, @resource)
      else undefined
