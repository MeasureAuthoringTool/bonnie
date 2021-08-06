# Input view for Identifier type
class Thorax.Views.InputIdentifierView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/identifier']

  initialize: ->
    @useView =  new Thorax.Views.InputCodeView({
      cqmValueSets: [ IdentifierUseValueSet.JSON ],
      codeSystemMap: @codeSystemMap,
      name: 'use'
      codeType: cqm.models.IdentifierUse
    })

    @typeView = new Thorax.Views.InputCodingView({
      cqmValueSets: [IdentifierTypeValueSet.JSON].concat(@cqmValueSets),
      codeSystemMap: @codeSystemMap,
      name: 'type'
    })

    @systemView = new Thorax.Views.InputStringView({ placeholder: 'uri', name: 'system' })
    @valueView = new Thorax.Views.InputStringView({ name: 'value' })
    @periodView = new Thorax.Views.InputPeriodView({ name: 'period', defaultYear: @defaultYear })
    @assignerView =  new Thorax.Views.InputStringView({ placeholder: 'registry/state/facility/etc', name: 'assigner' })
    @subviews = [ @useView, @typeView, @systemView, @valueView, @periodView, @assignerView ]

    @listenTo(view, 'valueChanged', @updateValueFromSubviews) for view in @subviews

  # checks if the view is valid.
  hasValidValue: ->
    !@isEmptyIdetifier()

  updateValueFromSubviews:  ->
    @value = new cqm.models.Identifier() unless @value?
    @update view for view in @subviews
    @trigger 'valueChanged', this

  update: (view) ->
    unless view.value
      @value[view.name] = undefined
      return @value

    switch view.name
      when @useView.name
        @value.use = view.value
      when @typeView.name
        @value.type = new cqm.models.CodeableConcept()
        @value.type.coding = [view.value]
      when @systemView.name
        @value.system = cqm.models.PrimitiveUri.parsePrimitive(view.value.value)
      when @assignerView.name
        if view.value
          @value.assigner = cqm.models.Reference.parse({display: view.value.value})
        else
          @value.assigner = undefined
      when @periodView.name
        if view.value?.start || view.value?.end
          @value.period = view.value
        else
          @value.period = undefined
      else
        @value[view.name] = view.value

  isEmptyIdetifier: ->
    identifier = @value || {}
    for value in Object.values(identifier)
      if value != undefined
        return false
    return true
