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
      @value = new cqm.models.CQL.Interval(null, null)

  events:
    'change input[type=checkbox]': 'handleCheckboxChange'
    # hide date-picker if it's still visible and focus is not on a .date-picker input (occurs with JAWS SR arrow-key navigation)
    'focus .form-control': (e) -> if not @$(e.target).hasClass('date-picker') and $('.datepicker').is(':visible') then @$('.date-picker').datepicker('hide')
    rendered: ->
      @$('.date-picker').datepicker('orientation': 'bottom left').on 'changeDate', _.bind(@handleChange, this)
      @$('.time-picker').timepicker(template: false, defaultTime: false).on 'changeTime.timepicker', _.bind(@handleChange, this)

  createDefault: ->
    todayInMP = new Date()
    # TODO: use measurement period for this
    todayInMP.setYear(2012)

    # create CQL DateTimes
    start = new cqm.models.CQL.DateTime(todayInMP.getFullYear(), todayInMP.getMonth() + 1, todayInMP.getDate(), 8, 0, 0, 0, 0)
    end = new cqm.models.CQL.DateTime(todayInMP.getFullYear(), todayInMP.getMonth() + 1, todayInMP.getDate(), 8, 15, 0, 0, 0)
    return new cqm.models.CQL.Interval(start, end)

  context: ->
    _(super).extend
      start_date_is_defined: @value.low?
      start_date: moment.utc(@value.low.toJSDate()).format('L') if @value.low?
      start_time: moment.utc(@value.low.toJSDate()).format('LT') if @value.low?
      end_date_is_defined: @value.high?
      end_date: moment.utc(@value.high.toJSDate()).format('L') if @value.high?
      end_time: moment.utc(@value.high.toJSDate()).format('LT') if @value.high?

  # handle the cases of either of the null checkboxes being changed
  handleCheckboxChange: (e) ->
    e.preventDefault()
    # check the status of the start checkbox and disable/enable fields
    if @$("input[name='start_date_is_defined']").prop("checked")
      @$("input[name='start_date'], input[name='start_time']").prop('disabled', false)
      # if date is empty create values and populate fields
      if @$("input[name='start_date']").val() == ""
        defaultStart = @createDefault().low
        @$("input[name='start_date']").val(moment.utc(defaultStart.toJSDate()).format('L'))
        @$("input[name='start_time']").val(moment.utc(defaultStart.toJSDate()).format('LT'))
        @$("input[name='start_date']").datepicker('update')
        @$("input[name='start_time']").timepicker('setTime', moment.utc(defaultStart.toJSDate()).format('LT'))
    else
      @$("input[name='start_date'], input[name='start_time']").prop('disabled', true).val("")

    # check the status of the end checkbox and disable/enable fields
    if @$("input[name='end_date_is_defined']").prop("checked")
      @$("input[name='end_date'], input[name='end_time']").prop('disabled', false)
      # if date is empty create values and populate fields
      if @$("input[name='end_date']").val() == ""
        defaultEnd = @createDefault().high
        @$("input[name='end_date']").val(moment.utc(defaultEnd.toJSDate()).format('L'))
        @$("input[name='end_time']").val(moment.utc(defaultEnd.toJSDate()).format('LT'))
        @$("input[name='end_date']").datepicker('update')
        @$("input[name='end_time']").timepicker('setTime', moment.utc(defaultEnd.toJSDate()).format('LT'))
    else
      @$("input[name='end_date'], input[name='end_time']").prop('disabled', true).val("")

    # now handle the rest of the fields to create a new interval
    @handleChange(e)

  # handle a change event on any of the fields.
  handleChange: (e) ->
    e.preventDefault()
    formData = @serialize()
    lowDateTime = null
    highDateTime = null

    if formData.start_date_is_defined?
      lowDateTime = cqm.models.CQL.DateTime.fromJSDate(moment.utc("#{formData.start_date} #{formData.start_time}", 'L LT').toDate(), 0)

    if formData.end_date_is_defined?
      highDateTime = cqm.models.CQL.DateTime.fromJSDate(moment.utc("#{formData.end_date} #{formData.end_time}", 'L LT').toDate(), 0)
    
    newInterval = new cqm.models.CQL.Interval(lowDateTime, highDateTime)
    
    # only change and fire the change event if there actually was a change
    if !newInterval.equals(@value)
      @value = newInterval
      @trigger 'valueChanged', @
