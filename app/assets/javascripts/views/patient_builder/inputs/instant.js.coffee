# Input view for DateTime types.
class Thorax.Views.InputInstantView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/instant']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - Optional. Initial value of datetime.
  #   showLabel - Boolean - Optional. To show the label for the attribute or not. Defaults to false.
  #                          If true, attributeName and attributeTitle should be specified.
  #   attributeName - String - Optional. The name/path of the attribue on the data element that this is editing.
  #   attributeTitle - String - Optional. The human friendly name of the attribute.
  #   defaultYear - Integer - Optional. The default year to use when a default date needs to be created.
  #                           This should be the measurement period. Defaults to 2020.
  #   allowNull - boolean - Optional. If a null DateTime is allowed to be null. Defaults to true.
  initialize: ->
    if cqm.models.PrimitiveInstant.isPrimitiveInstant(@initialValue)
      cqlDateTime = cqm.models.CQL.DateTime.fromJSDate(moment.utc(@initialValue.value).toDate(), 0);
    else
      cqlDateTime = null

    @view = new Thorax.Views.InputCqlDateTimeView({
      initialValue: cqlDateTime,
      showLabel: @showLabel,
      attributeName: @attributeName,
      attributeTitle: @attributeTitle,
      defaultYear: @defaultYear,
      allowNull: @allowNull
    })
    @listenTo(@view, 'valueChanged', @handleChange)
    @updateValue()

  hasValidValue: ->
    @view.hasValidValue()

  # handle a change event on any of the fields.
  handleChange: (e) ->
    @updateValue()
    @trigger 'valueChanged', this

  updateValue: ->
    @value = if @view.value? then DataCriteriaHelpers.getPrimitiveDateTimeForCqlDateTime(@view.value) else null

