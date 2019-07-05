# Input view for Time types.
# TODO: Update to use CQL Time type when it is created.
class Thorax.Views.InputTimeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/time']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - CQL DateTime - Optional. Initial value of datetime.
  #   allowNull - boolean - Optional. If a null DateTime is allowed to be null. Defaults to true.
  initialize: ->
    if @initialValue?
      @value = @initialValue.copy()
    else
      @value = null

    if !@hasOwnProperty('allowNull')
      @allowNull = true

  events:
    'change input[type=checkbox]': 'handleCheckboxChange'
    rendered: ->
      @$('.time-picker').timepicker(template: false, defaultTime: false).on 'changeTime.timepicker', _.bind(@handleChange, this)

  createDefault: ->
    todayInMP = new Date()
    todayInMP.setYear(@defaultYear)

    # create CQL Times
    return new cqm.models.CQL.DateTime(2000, 1, 1, 8, 0, 0, 0, 0).getTime()

  context: ->
    _(super).extend
      time_is_defined: @value?
      time: moment.utc(@value.toJSDate()).format('LT') if @value?

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  # handle the cases the null checkbox being changed
  handleCheckboxChange: (e) ->
    e.preventDefault()
    # check the status of the checkbox and disable/enable fields
    if @$("input[name='time_is_defined']").prop("checked")
      @$("input[name='time']").prop('disabled', false)
      defaultDate = @createDefault()
      @$("input[name='time']").val(moment.utc(defaultDate.toJSDate()).format('LT'))
      @$("input[name='time']").timepicker('setTime', moment.utc(defaultDate.toJSDate()).format('LT'))
    else
      @$("input[name='time']").prop('disabled', true).val("")

    # now handle the rest of the fields to create a new date
    @handleChange(e)

  # handle a change event on any of the fields.
  handleChange: (e) ->
    e.preventDefault()
    formData = @serialize()
    newTime = null

    if formData.time_is_defined?
      # TODO: replace with real Time type instead of making a cql DateTime.
      newTime = cqm.models.CQL.DateTime.fromJSDate(moment.utc("01/01/2000 #{formData.time}", 'L LT').toDate(), 0).getTime()

    # only change and fire the change event if there actually was a change
    # if before and after are null, just return
    return if !@value? && !newTime?

    # if before and after are defined trigger change
    if (@value? && newTime?)
      if !@value.equals(newTime)
        @value = newTime
        @trigger 'valueChanged', @

    # if either before xor after was null trigger change
    else
      @value = newTime
      @trigger 'valueChanged', @
