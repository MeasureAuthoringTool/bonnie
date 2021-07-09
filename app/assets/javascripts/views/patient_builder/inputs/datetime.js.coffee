# Input view for DateTime types.
class Thorax.Views.InputDateTimeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/datetime']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - CQL DateTime - Optional. Initial value of datetime.
  #   showLabel - Boolean - Optional. To show the label for the attribute or not. Defaults to false.
  #                          If true, attributeName and attributeTitle should be specified.
  #   attributeName - String - Optional. The name/path of the attribue on the data element that this is editing.
  #   attributeTitle - String - Optional. The human friendly name of the attribute.
  #   defaultYear - Integer - Optional. The default year to use when a default date needs to be created.
  #                           This should be the measurement period. Defaults to 2012.
  #   allowNull - boolean - Optional. If a null DateTime is allowed to be null. Defaults to true.
  initialize: ->
    if @initialValue?
      @value = @initialValue.copy()
    else
      @value = null

    if !@defaultYear?
      @defaultYear = 2012

    if !@hasOwnProperty('allowNull')
      @allowNull = true

  events:
    'change input[type=checkbox]': 'handleCheckboxChange'
    # hide date-picker if it's still visible and focus is not on a .date-picker input (occurs with JAWS SR arrow-key navigation)
    'focus .form-control': (e) -> if not @$(e.target).hasClass('date-picker') and $('.datepicker').is(':visible') then @$('.date-picker').datepicker('hide')
    rendered: ->
      @$('.date-picker').datepicker('orientation': 'bottom left').on 'changeDate', _.bind(@handleChange, this)
      @$('.time-picker').timepicker(template: false, defaultTime: false).on 'changeTime.timepicker', _.bind(@handleChange, this)

  createDefault: ->
    todayInMP = new Date()
    todayInMP.setYear(@defaultYear)

    # create CQL DateTimes
    return new cqm.models.CQL.DateTime(todayInMP.getFullYear(), todayInMP.getMonth() + 1, todayInMP.getDate(), 8, 0, 0, 0, 0)

  context: ->
    _(super).extend
      date_is_defined: @value?
      date: moment.utc(@value.toJSDate()).format('L') if @value?
      time: moment.utc(@value.toJSDate()).format('LT') if @value?

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  # handle the cases the null checkbox being changed
  handleCheckboxChange: (e) ->
    e.preventDefault()
    # check the status of the checkbox and disable/enable fields
    if @$("input[name='date_is_defined']").prop("checked")
      @$("input[name='date'], input[name='time']").prop('disabled', false)
      # if date is empty create values and populate fields
      if @$("input[name='date']").val() == ""
        defaultDate = @createDefault()
        @$("input[name='date']").val(moment.utc(defaultDate.toJSDate()).format('L'))
        @$("input[name='time']").val(moment.utc(defaultDate.toJSDate()).format('LT'))
        @$("input[name='date']").datepicker('update')
        @$("input[name='time']").timepicker('setTime', moment.utc(defaultDate.toJSDate()).format('LT'))
    else
      @$("input[name='date'], input[name='time']").prop('disabled', true).val("")

    # now handle the rest of the fields to create a new date
    @handleChange(e)

  # handle a change event on any of the fields.
  handleChange: (e) ->
    e.preventDefault()
    formData = @serialize()
    newDateTime = null

    if formData.date_is_defined?
      dateFormatted = moment(@$('input[name="date"]').datepicker('getDate')).format('L')
      newDateTime = cqm.models.CQL.DateTime.fromJSDate(moment.utc("#{dateFormatted} #{formData.time}", 'L LT').toDate(), 0)

    # only change and fire the change event if there actually was a change
    # if before and after are null, just return
    return if !@value? && !newDateTime?

    # if before and after are defined trigger change
    if (@value? && newDateTime?)
      if !@value.equals(newDateTime)
        @value = newDateTime
        @trigger 'valueChanged', @

    # if either before xor after was null trigger change
    else
      @value = newDateTime
      @trigger 'valueChanged', @
