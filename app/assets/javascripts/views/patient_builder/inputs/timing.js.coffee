# Input view for Sampled Data types.
class Thorax.Views.InputTimingView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/timing']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - Timing - Optional. Initial value of timing.
  #   codeSystemMap - required
  #   defaultYear - required
  initialize: ->
    @timingEventView = new Thorax.Views.InputDateTimeView(initialValue: @value?.event?[0], defaultYear: @defaultYear, name: 'event', allowNull: false)
    @timingRepeatView = new Thorax.Views.InputTimingRepeatView(initialValue: @value?.repeat, name: 'repeat', codeSystemMap: @codeSystemMap, defaultYear: @defaultYear)
    @timingCodeView = new Thorax.Views.InputCodingView({ initialValue: @value?.code?.coding, name: 'code', cqmValueSets: [FhirValueSets.TIMING_ABBREVIATION_VS], codeSystemMap: @codeSystemMap })
    @subviews = [ @timingEventView, @timingRepeatView, @timingCodeView ]
    @listenTo(view, 'valueChanged', @updateValueFromSubviews) for view in @subviews

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @timingEventView.hasValidValue() || @timingCodeView.hasValidValue() || @timingRepeatView.hasValidValue()

  update: (view) ->
    switch view.name
      when @timingEventView.name
        if view.value?
          @value.event = [ DataCriteriaHelpers.getPrimitiveDateTimeForCqlDateTime(view.value) ]
        else
          @value.event = undefined
      when @timingCodeView.name
        if view.value?
          @value.code = new cqm.models.CodeableConcept()
          @value.code.coding = [ view.value ]
        else
          @value.code = undefined
      when @timingRepeatView.name
        if view.value?
          @value.repeat = view.value
        else
          @value.repeat = undefined

  updateValueFromSubviews: ->
    @value = new cqm.models.Timing() unless @value?
    @update view for view in @subviews
    @trigger 'valueChanged', @

