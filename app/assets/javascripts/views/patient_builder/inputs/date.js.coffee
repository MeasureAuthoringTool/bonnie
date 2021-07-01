# Input view for Date types.
class Thorax.Views.InputDateView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/date']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - CQL Date - Optional. Initial value of date.
  #   showLabel - Boolean - Optional. To show the label for the attribute or not. Defaults to false.
  #                          If true, attributeName and attributeTitle should be specified.
  #   attributeName - String - Optional. The name/path of the attribue on the data element that this is editing.
  #   attributeTitle - String - Optional. The human friendly name of the attribute.
  #   defaultYear - Integer - Optional. The default year to use when a default date needs to be created.
  #                           This should be the measurement period. Defaults to 2012.
  #   allowNull - boolean - Optional. If a null Date is allowed to be null. Defaults to true.
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

  createDefault: ->
    todayInMP = new Date()
    todayInMP.setYear(@defaultYear)

    # create CQL Date
    return new cqm.models.CQL.Date(todayInMP.getFullYear(), todayInMP.getMonth() + 1, todayInMP.getDate())

  context: ->
    _(super).extend
      date_is_defined: @value?
      date: moment.utc(@value.toJSDate()).format('L') if @value?

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  # handle the cases the null checkbox being changed
  handleCheckboxChange: (e) ->
    e.preventDefault()
    # check the status of the checkbox and disable/enable fields
    if @$("input[name='date_is_defined']").prop("checked")
      @$("input[name='date']").prop('disabled', false)
      # if date is empty create values and populate fields
      if @$("input[name='date']").val() == ""
        defaultDate = @createDefault()
        @$("input[name='date']").val(moment.utc(defaultDate.toJSDate()).format('L'))
        @$("input[name='date']").datepicker('update')
    else
      @$("input[name='date']").prop('disabled', true).val("")

    # now handle the rest of the fields to create a new date
    @handleChange(e)

  # handle a change event on any of the fields.
  handleChange: (e) ->
    e.preventDefault()
    formData = @serialize()
    newDate = null

    if formData.date_is_defined?
      momentDate = moment.utc(@$('input[name="date"]').datepicker('getDate'))
      # Moment uses 0-indexed months, hence the + 1
      newDate = new cqm.models.CQL.Date(momentDate.year(), momentDate.month() + 1, momentDate.date())

    # only change and fire the change event if there actually was a change
    # if before and after are null, just return
    return if !@value? && !newDate?

    # if before and after are defined trigger change
    if (@value? && newDate?)
      if !@value.equals(newDate)
        @value = newDate
        @trigger 'valueChanged', @

    # if either before xor after was null trigger change
    else
      @value = newDate
      @trigger 'valueChanged', @
