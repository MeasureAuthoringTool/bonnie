# Input view for Interval<DateTime> types.
class Thorax.Views.InputIntervalDateTimeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/interval_datetime']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - Interval<DateTime> - Optional. Initial value of interval.
  #   showLabel - Boolean - Optional. To show the label for the attribute or not. Defaults to false.
  #                          If true, attributeName and attributeTitle should be specified.
  #   attributeName - String - Optional. The name/path of the attribue on the data element that this is editing.
  #   attributeTitle - String - Optional. The human friendly name of the attribute.
  initialize: ->
    if @initialValue?
      @value = @initialValue.copy()
    else
      @value = @createDefault()

  createDefault: ->
    todayInMP = new Date()
    # TODO: use measurement period for this
    todayInMP.setYear(2012)
    todayInMP.setHours(8)
    todayInMP.setMinutes(0)
    todayInMP.setMilliseconds(0)
    todayInMPEnd = new Date(todayInMP)
    todayInMPEnd.setMinutes(15)
    return new cqm.models.CQL.Interval(cqm.models.CQL.DateTime.fromJSDate(todayInMP, 0),
      cqm.models.CQL.DateTime.fromJSDate(todayInMPEnd, 0))

  context: ->
    _(super).extend
      start_date_is_defined: @value.low?
      start_date: moment(@value.low.toJSDate()).format('L') if @value.low?
      start_time: moment(@value.low.toJSDate()).format('LT') if @value.low?
      end_date_is_defined: @value.high?
      end_date: moment(@value.high.toJSDate()).format('L') if @value.high?
      end_time: moment(@value.high.toJSDate()).format('LT') if @value.high?