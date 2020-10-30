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
    'change input[type=time]': 'handleChange'

  createDefault: ->
    time = new cqm.models.CQL.DateTime(2000, 1, 1, 8, 0, 0, 0, 0).getTime()
    @getTimeString(time)

  getTimeString: (time) ->
    paddedHour = String("0#{time.hour}").slice(-2)
    paddedMin = String("0#{time.minute}").slice(-2)
    "#{paddedHour}:#{paddedMin}"

  context: ->
    _(super).extend
      time_is_defined: @value?
      time: @getTimeString(@value) if @value?

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  handleCheckboxChange: (e) ->
    e.preventDefault()
    if @$("input[name='time_is_defined']").prop("checked")
      @$("input[name='time']").prop('disabled', false).val(@createDefault())
    else
      @$("input[name='time']").prop('disabled', true).val('')
    @handleChange(e)

  handleChange: (e) ->
    e.preventDefault()
    formData = @serialize()
    @value = if !!formData.time then cqm.models.PrimitiveTime.parsePrimitive(formData.time) else null
    console.log(@value)
    @trigger 'valueChanged', @
