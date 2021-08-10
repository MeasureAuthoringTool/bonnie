# Input view for ObservationComponent types.
class Thorax.Views.InputObservationComponentView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/observation_component']

  # Expected options to be passed in using the constructor options hash:
  #   codeSystemMap - required
  #   cqmValueSets  - required
  #   defaultYear   - required
  initialize: ->
    @value = null
    @observationComponentCodeView = new Thorax.Views.InputCodeableConceptView({ name: 'code', cqmValueSets: [LOINCCodesValueSet.JSON], codeSystemMap: @codeSystemMap })
    @observationComponentValueView = new Thorax.Views.InputAnyView({
      attributeName: 'value',
      name: 'value',
      defaultYear: @defaultYear,
      types: ['Quantity', 'CodeableConcept', 'String', 'Boolean', 'Integer',
        'Range', 'Ratio', 'SampledData','Time', 'DateTime', 'Period']
      cqmValueSets: @cqmValueSets,
      codeSystemMap: @codeSystemMap
    })
    @subviews = [ @observationComponentCodeView, @observationComponentValueView ]
    @listenTo(view, 'valueChanged', @updateValueFromSubviews) for view in @subviews

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    (@observationComponentCodeView.hasValidValue()  || @observationComponentValueView.hasValidValue())

  update: (view) ->
    if view.value?
      @value[view.name] = view.value
    else
      @value[view.name] = undefined

  updateValueFromSubviews: ->
    @value = new cqm.models.ObservationComponent() unless @value?
    @update view for view in @subviews
    @trigger 'valueChanged', this
