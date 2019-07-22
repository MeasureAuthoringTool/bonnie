class Thorax.Views.InputRelatedToView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/related_to']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - Data Element Id (String) - Optional. Initial value of relatedTo.
  #   sourceDataCriteria - Array of current Data Elements on the patient
  #   currentDataElementId - String - Id of the data element to which this relatedTo belongs
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = null

    # Do not include the current DataElement in the list of available Data Elements
    dataElements = []
    for dataElement in @sourceDataCriteria.models
      unless dataElement.get('qdmDataElement').id == @currentDataElementId
        dataElements.push(dataElement)
    @sourceDataCriteria.models = dataElements

  events:
    'change select[name="related_to"]': 'handleRelatedToChange'

  hasValidValue: ->
    @value?

  @getDisplayFromId: (sourceDataCriteria, id) ->
    # Description plus timing attributes
    for dataElement in sourceDataCriteria.models
      if dataElement.get('id') == id
        primaryTimingAttribute = dataElement.getPrimaryTimingAttribute()
        timing = dataElement.get('qdmDataElement')[primaryTimingAttribute]
        description = "#{dataElement.get('qdmDataElement').description}"
        return { description: description, timing: timing }
    return null

  handleRelatedToChange: (e) ->
    id = @$('select[name="related_to"]').val()
    @value = {
      isRelatedTo: true,
      id: id,
      display: Thorax.Views.InputRelatedToView.getDisplayFromId(@sourceDataCriteria, id)
    }
    @trigger 'valueChanged', @