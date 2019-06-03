# Input view for DateTime types.
class Thorax.Views.InputDateTimeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/datetime']

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
    return cqm.models.CQL.DateTime.fromJSDate(todayInMP, 0)

  context: ->
    _(super).extend
      date_is_defined: @value?
      date: moment(@value.toJSDate()).format('L') if @value?
      time: moment(@value.toJSDate()).format('LT') if @value?
