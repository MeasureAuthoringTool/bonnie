# Input view for Sampled Data types.
class Thorax.Views.InputTimingRepeatView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/timingrepeat']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - sampledData - Optional. Initial value of sampledData.
  #   codeSystemMap - required
  #   defaultYear - required
  initialize: ->
    @boundsView = new Thorax.Views.InputAnyView({ attributeName: 'bounds', defaultYear: @defaultYear, codeSystemMap: @codeSystemMap, types: ['Duration', 'Range', 'Period'] })
    @countView = new Thorax.Views.InputPositiveIntegerView({ initialValue: @value?.count, allowNull: true, name: 'countView' })
    @countMaxView = new Thorax.Views.InputPositiveIntegerView({ initialValue: @value?.countMax, allowNull: true, name: 'countMaxView' })
    @durationView = new Thorax.Views.InputDecimalView({ initialValue: @value?.duration, allowNull: false, name: 'durationView' })
    @durationMaxView = new Thorax.Views.InputDecimalView(initialValue: @value?.durationMax, allowNull: false, name: 'durationMaxView')
    @durationUnitView =  new Thorax.Views.InputCodeView({ initialValue: @value?.durationUnit, cqmValueSets: [ UnitsOfTimeValueSet.JSON ], codeSystemMap: @codeSystemMap, name: 'durationUnitView' })
    @frequencyView = new Thorax.Views.InputPositiveIntegerView({ initialValue: @value?.frequency, allowNull: true, name: 'frequencyView' })
    @frequencyMaxView = new Thorax.Views.InputPositiveIntegerView({ initialValue: @value?.frequencyMax, allowNull: true, name: 'frequencyMaxView' })
    @periodView = new Thorax.Views.InputDecimalView({ initialValue: @value?.period, allowNull: false, name: 'periodView' })
    @periodMaxView = new Thorax.Views.InputDecimalView({ initialValue: @value?.periodMax, allowNull: false, name: 'periodMaxView' })
    @periodUnitView = new Thorax.Views.InputCodeView({ initialValue: @value?.periodUnit, cqmValueSets: [ UnitsOfTimeValueSet.JSON ], codeSystemMap: @codeSystemMap, name: 'periodUnitView' })
    @dayOfWeekView = new Thorax.Views.InputCodeView({ initialValue: @value?.dayOfWeek, cqmValueSets: [ DaysOfWeekValueSet.JSON ], codeSystemMap: @codeSystemMap, name: 'dayOfWeekView' })
    @timeOfDayView = new Thorax.Views.InputTimeView({ initialValue: @value?.timeOfDay, allowNull: false, name: 'timeOfDayView' })
    @whenView =  new Thorax.Views.InputCodeView({ initialValue: @value?.when, cqmValueSets: [ EventTimingValueSet.JSON ], codeSystemMap: @codeSystemMap, name: 'whenView' })
    @offsetView = new Thorax.Views.InputUnsignedIntegerView({ initialValue: @value?.offset, allowNull: true, name: 'offsetView' })

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
    validValue = @subviews.map(
      (view) -> view.hasValidValue()
    ).reduce(
      (acc, curr) ->  acc = acc || curr,
      false
    )
    return validValue

  update: (view) ->
    switch view.name
      when @boundsView.new
        if view.value?
          @value.bounds = view.value
        else
          @value.bounds = undefined
      when @countView.name
        if view.value?
          @value.count = view.value
        else
          @value.count = undefined
      when @countMaxView.name
        if view.value?
          @value.countMax = view.value
        else
          @value.countMax = undefined
      when @durationView.name
        if view.value?
          @value.duration = view.value
        else
          @value.duration = undefined
      when @durationMaxView.name
        if view.value?
          @value.durationMax = view.value
        else
          @value.durationMax = undefined
      when @durationUnitView.name
        if view.value?
          @value.durationUnit = cqm.models.UnitsOfTime.parsePrimitive(view.value)
        else
          @value.durationUnit = undefined
      when @frequencyView.name
        if view.value?
          @value.frequency = view.value
        else
          @value.frequency = undefined
      when @frequencyMaxView.name
        if view.value?
          @value.frequencyMax = view.value
        else
          @value.frequencyMax = undefined
      when @periodView.name
        if view.value?
          @value.period = view.value
        else
          @value.period = undefined
      when @periodMaxView.name
        if view.value?
          @value.periodMax = view.value
        else
          @value.periodMax = undefined
      when @periodUnitView.name
        if view.value?
          @value.periodUnit = cqm.models.UnitsOfTime.parsePrimitive(view.value)
        else
          @value.periodUnit = undefined
      when @dayOfWeekView.name
        if view.value?
          @value.dayOfWeek = [ cqm.models.DayOfWeek.parsePrimitive(view.value) ]
        else
          @value.dayOfWeek = undefined
      when @timeOfDayView.name
        if view.value?
          @value.timeOfDay = [ view.value ]
        else
          @value.timeOfDay = undefined
      when @whenView.name
        if view.value?
          @value.when = [ cqm.models.EventTiming.parsePrimitive(view.value) ]
        else
          @value.when = undefined
      when @offsetView.name
        if view.value?
          @value.offset = view.value
        else
          @value.offset = undefined


  updateValueFromSubviews: ->
    @value = new cqm.models.TimingRepeat() unless @value?
    @update view for view in @subviews
    @trigger 'valueChanged', @

