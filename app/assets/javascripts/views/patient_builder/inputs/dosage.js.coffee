# Input view for Dosage type
class Thorax.Views.InputDosageView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/dosage']

  # Expected options to be passed in using the constructor options hash:
  # cqmValueSets - required - measure value sets
  # initialValue - Timing - Optional. Initial value of timing
  # codeSystemMap - required
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = null
    @sequenceView = new Thorax.Views.InputIntegerView({ name: 'sequence' })
    @textView = new Thorax.Views.InputStringView({ name: 'text' })
    @patientInstructionView = new Thorax.Views.InputStringView({ name: 'patientInstruction' })
    @maxDosePerPeriodView = new Thorax.Views.InputRatioView({ name: 'maxDosePerPeriod' })
    @maxDosePerAdministrationView = new Thorax.Views.InputQuantityView({ name: 'maxDosePerAdministration' })
    @maxDosePerLifetimeView = new Thorax.Views.InputQuantityView({ name: 'maxDosePerLifetime' })
    @additionalInstructionView = new Thorax.Views.InputCodingView({
      cqmValueSets: [AdditionalDosageInstructions.JSON].concat(@cqmValueSets),
      codeSystemMap: @codeSystemMap,
      name: 'additionalInstruction'
    })
    @asNeededView = new Thorax.Views.InputAnyView({
      attributeName: 'asNeeded',
      name: 'asNeeded',
      cqmValueSets: [MedicationAsNeededReasonCodes.JSON].concat(@cqmValueSets),
      codeSystemMap: @codeSystemMap,
      types: ['Boolean', 'CodeableConcept']
    })
    @siteView = new Thorax.Views.InputCodingView({
      cqmValueSets: [AdministrationSiteCodes.JSON].concat(@cqmValueSets),
      codeSystemMap: @codeSystemMap,
      name: 'site'
    })
    @routeView = new Thorax.Views.InputCodingView({
      cqmValueSets: [RouteCodes.JSON].concat(@cqmValueSets),
      codeSystemMap: @codeSystemMap,
      name: 'route'
    })
    @methodView = new Thorax.Views.InputCodingView({
      cqmValueSets: [AdministrationMethodCodes.JSON].concat(@cqmValueSets),
      codeSystemMap: @codeSystemMap,
      name: 'method'
    })
    @typeView = new Thorax.Views.InputCodingView({
      cqmValueSets: [DoseAndRateType.JSON].concat(@cqmValueSets),
      codeSystemMap: @codeSystemMap,
      name: "type"
    })
    @doseView = new Thorax.Views.InputAnyView({
      attributeName: 'dose',
      name: 'dose',
      defaultYear: @defaultYear,
      types: ['Range', 'SimpleQuantity']
    })

    @rateView = new Thorax.Views.InputAnyView({
      attributeName: 'rate',
      name: 'rate',
      defaultYear: @defaultYear,
      types: ['Ratio', 'Range', 'SimpleQuantity']
    })

    @subviews = [
      @sequenceView, @textView, @additionalInstructionView, @patientInstructionView,
      @siteView, @routeView, @methodView, @maxDosePerPeriodView, @maxDosePerAdministrationView,
      @maxDosePerLifetimeView, @typeView, @asNeededView, @doseView, @rateView
    ]

    @listenTo(view, 'valueChanged', @updateValueFromSubviews) for view in @subviews

  hasValidValue: ->
    $("div[data-view-cid=#{@.cid}] .has-error").length == 0 && !@isEmptyDosage()

  updateValueFromSubviews: ->
    @value = new cqm.models.Dosage() unless @value?
    @update view for view in @subviews
    @trigger 'valueChanged', this

  update: (view) ->
    switch view.name
      when @additionalInstructionView.name
        if view.value?
          @value[view.name] = [new cqm.models.CodeableConcept()]
          @value[view.name][0].coding = [view.value]
        else
          @value[view.name] = undefined
      when @siteView.name, @routeView.name, @methodView.name
        if view.value?
          @value[view.name] = new cqm.models.CodeableConcept()
          @value[view.name].coding = [view.value]
        else
          @value[view.name] = undefined
      when @maxDosePerAdministrationView.name, @maxDosePerLifetimeView.name
        if view.value?
          @value[view.name] = new cqm.models.SimpleQuantity()
          @value[view.name] = view.value
        else
          @value[view.name] = undefined
      when @typeView.name, @doseView.name, @rateView.name
        @updateDosageAndRate(view)
      else
        @value[view.name] = if view.value? then view.value else undefined

  updateDosageAndRate: (view) ->
    @value.doseAndRate = [ new cqm.models.DosageDoseAndRate() ] unless @value.doseAndRate
    if view.name == 'type' && view.value?
      @value.doseAndRate[0].type = new cqm.models.CodeableConcept()
      @value.doseAndRate[0].type.coding = [view.value]
    else if view.currentType == 'SimpleQuantity' && view.value?
      @value.doseAndRate[0][view.name] = cqm.models.SimpleQuantity.parse(view.value.toJSON())
    else
      @value.doseAndRate[0][view.name] = if view.value? then view.value else undefined

    # Set doseAndRate to undefined if none of the doseAndRate attr has value
    @value.doseAndRate = undefined unless @value.doseAndRate[0].type? || @value.doseAndRate[0].dose? || @value.doseAndRate[0].rate?

  isEmptyDosage: ->
    dosage = @value || {}
    for value in Object.values(dosage)
      if value != undefined
        return false
    return true
