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

  events:
    'change input[type=text]': 'handleChange'
    'change input[type=checkbox]': 'handleCheckboxChange'

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
      date: moment.utc(@value.toJSDate()).format('L') if @value?
      time: moment.utc(@value.toJSDate()).format('LT') if @value?

  # handle the cases the null checkbox being changed
  handleCheckboxChange: (e) ->
    # check the status of the checkbox and disable/enable fields
    if @$("input[name='date_is_defined']").prop("checked")
      @$("input[name='date'], input[name='time']").prop('disabled', false)
      # if date is empty create values and populate fields
      if @$("input[name='date']").val() == ""
        defaultDate = @createDefault()
        @$("input[name='date']").val(moment.utc(defaultDate.toJSDate()).format('L'))
        @$("input[name='time']").val(moment.utc(defaultDate.toJSDate()).format('LT'))
    else
      @$("input[name='date'], input[name='time']").prop('disabled', true).val("")

    # now handle the rest of the fields to create a new date
    @handleChange()

  # handle a change event on any of the fields.
  handleChange: (e) ->
    formData = @serialize()
    newDateTime = null

    if formData.date_is_defined?
      newDateTime = cqm.models.CQL.DateTime.fromJSDate(moment.utc("#{formData.date} #{formData.time}", 'L LT').toDate(), 0)

    # only change and fire the change event if there actually was a change
    # if before and after are null, just return
    return if !@value? && !newDateTime?

    # if before and after are defined trigger change
    if (@value? && newDateTime?)
      if !@value.equals(newDateTime)
        @value = newDateTime
        @trigger 'change', @

    # if either before xor after was null trigger change
    else
      @value = newDateTime
      @trigger 'change', @
