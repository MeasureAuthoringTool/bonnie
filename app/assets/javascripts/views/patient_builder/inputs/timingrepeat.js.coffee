# Input view for TimingRepeat types.
class Thorax.Views.InputTimingRepeatView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/timingrepeat']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - sampledData - Optional. Initial value of sampledData.
  #   codeSystemMap - required
  #   defaultYear - required
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = null
    @boundsView = new Thorax.Views.InputAnyView({
      attributeName: 'bounds',
      defaultYear: @defaultYear,
      codeSystemMap: @codeSystemMap,
      types: ['Duration', 'Range', 'Period'],
      update: (view) =>
        if view.value?
          @value.bounds = view.value
        else
          @value.bounds = undefined
    })
    @countView = new Thorax.Views.InputPositiveIntegerView({
      initialValue: @value?.count,
      allowNull: true,
      name: 'countView',
      update: (view) =>
        if view.value?
          @value.count = view.value
        else
          @value.count = undefined
    })
    @countMaxView = new Thorax.Views.InputPositiveIntegerView({
      initialValue: @value?.countMax,
      allowNull: true,
      name: 'countMaxView',
      update: (view) =>
        if view.value?
          @value.countMax = view.value
        else
          @value.countMax = undefined
    })
    @durationView = new Thorax.Views.InputDecimalView({
      initialValue: @value?.duration,
      allowNull: false,
      name: 'durationView',
      update: (view) =>
        if view.value?
          @value.duration = view.value
        else
          @value.duration = undefined
    })
    @durationMaxView = new Thorax.Views.InputDecimalView({
      initialValue: @value?.durationMax,
      allowNull: false,
      name: 'durationMaxView',
      update: (view) =>
        if view.value?
          @value.durationMax = view.value
        else
          @value.durationMax = undefined
    })
    @durationUnitView =  new Thorax.Views.InputCodeView({
      initialValue: @value?.durationUnit,
      cqmValueSets: [ UnitsOfTimeValueSet.JSON ],
      codeSystemMap: @codeSystemMap,
      name: 'durationUnitView',
      update: (view) =>
        if view.value?
          @value.durationUnit = cqm.models.UnitsOfTime.parsePrimitive(view.value)
        else
          @value.durationUnit = undefined
    })
    @frequencyView = new Thorax.Views.InputPositiveIntegerView({
      initialValue: @value?.frequency,
      allowNull: true,
      name: 'frequencyView',
      update: (view) =>
        if view.value?
          @value.frequency = view.value
        else
          @value.frequency = undefined
    })
    @frequencyMaxView = new Thorax.Views.InputPositiveIntegerView({
      initialValue: @value?.frequencyMax,
      allowNull: true,
      name: 'frequencyMaxView',
      update: (view) =>
        if view.value?
          @value.frequencyMax = view.value
        else
          @value.frequencyMax = undefined
    })
    @periodView = new Thorax.Views.InputDecimalView({
      initialValue: @value?.period,
      allowNull: false,
      name: 'periodView',
      update: (view) =>
        if view.value?
          @value.period = view.value
        else
          @value.period = undefined
    })
    @periodMaxView = new Thorax.Views.InputDecimalView({
      initialValue: @value?.periodMax,
      allowNull: false,
      name: 'periodMaxView',
      update: (view) =>
        if view.value?
          @value.periodMax = view.value
        else
          @value.periodMax = undefined
    })
    @periodUnitView = new Thorax.Views.InputCodeView({
      initialValue: @value?.periodUnit,
      cqmValueSets: [ UnitsOfTimeValueSet.JSON ],
      codeSystemMap: @codeSystemMap,
      name: 'periodUnitView',
      update: (view) =>
        if view.value?
          @value.periodUnit = cqm.models.UnitsOfTime.parsePrimitive(view.value)
        else
          @value.periodUnit = undefined
    })
    @dayOfWeekView = new Thorax.Views.InputCodeView({
      initialValue: @value?.dayOfWeek,
      cqmValueSets: [ DaysOfWeekValueSet.JSON ],
      codeSystemMap: @codeSystemMap,
      name: 'dayOfWeekView',
      update: (view) =>
        if view.value?
          @value.dayOfWeek = [ cqm.models.DayOfWeek.parsePrimitive(view.value) ]
        else
          @value.dayOfWeek = undefined
    })
    @timeOfDayView = new Thorax.Views.InputTimeView({
      initialValue: @value?.timeOfDay,
      allowNull: false,
      name: 'timeOfDayView',
      update: (view) =>
        if view.value?
          @value.timeOfDay = [ view.value ]
        else
          @value.timeOfDay = undefined
    })
    @whenView =  new Thorax.Views.InputCodeView({
      initialValue: @value?.when,
      cqmValueSets: [ EventTimingValueSet.JSON ],
      codeSystemMap: @codeSystemMap,
      name: 'whenView',
      update: (view) =>
        if view.value?
          @value.when = [ cqm.models.EventTiming.parsePrimitive(view.value) ]
        else
          @value.when = undefined
    })
    @offsetView = new Thorax.Views.InputUnsignedIntegerView({
      initialValue: @value?.offset,
      allowNull: true,
      name: 'offsetView',
      update: (view) =>
        if view.value?
          @value.offset = view.value
        else
          @value.offset = undefined
    })

    @subviews = [
      @boundsView,
      @countView,
      @countMaxView,
      @durationView,
      @durationMaxView,
      @durationUnitView,
      @frequencyView,
      @frequencyMaxView,
      @periodView,
      @periodMaxView,
      @periodUnitView,
      @dayOfWeekView,
      @timeOfDayView,
      @whenView,
      @offsetView
    ]
    @listenTo(view, 'valueChanged', @updateValueFromSubviews) for view in @subviews

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    return @subviews.map(
      (view) -> view.value?
    ).reduce(
      (acc, curr) ->  acc = acc || curr,
      false
    )

  hasInvalidInput: ->
    return @subviews.map(
      (view) -> view.hasInvalidInput?()
    ).reduce(
      (acc, curr) ->  acc = acc || curr,
      false
    )

  update: (view) ->
    view.update(view)

  updateValueFromSubviews: ->
    @value = new cqm.models.TimingRepeat() unless @value?
    @update view for view in @subviews
    @trigger 'valueChanged', this

