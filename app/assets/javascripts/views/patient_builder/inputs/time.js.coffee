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
    time = new cqm.models.CQL.DateTime(2000, 1, 1, 8, 0, 0, 0, 0).getTime()
    @getTimeString(time)

  getTimeString:  (time) ->
    # Build time string with format HH:MM PP
    isAm = true
    if time.hour >= 12
      isAm = false
      time.hour = time.hour - 12

    if isAm
      end = ' AM'
    else
      end = ' PM'

    # Pad hour/minute if only 1 digit
    paddedHour = String("0" + time.hour).slice(-2)
    paddedMin = String("0" + time.minute).slice(-2)
    timeString = paddedHour + ':' + paddedMin + end
    timeString

  context: ->
    _(super).extend
      time_is_defined: @value?
      time: @getTimeString(@value) if @value?

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
      defaultTime = @createDefault()
      @$("input[name='time']").val(defaultTime)
      @$("input[name='time']").timepicker('setTime', defaultTime)
    else
      @$("input[name='time']").prop('disabled', true).val("")

    # now handle the rest of the fields to create a new date
    @handleChange(e)

  # handle a change event on any of the fields.
  handleChange: (e) ->
    e.preventDefault()
    formData = @serialize()
    newTimeString = null

    if formData.time_is_defined?
      [time, period] = formData.time.split(' ')
      [hour, minute] = time.split(':')
      hour = parseInt(hour)
      if (period == 'PM')
        newTimeString = "#{hour + 12}:#{minute}:00"
      else
        if (hour == 12) 
          hour = '00'
        newTimeString = "#{hour}:#{minute}:00"
      newTime = cqm.models.PrimitiveTime.parsePrimitive(newTimeString)
      @value = newTime
      @trigger 'valueChanged', @
