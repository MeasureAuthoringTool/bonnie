# Input view for Any types in composite views
# returns result in a form of { 'type': 'ResourceType', 'vs': 'ValueSetId' }
class Thorax.Views.InputReferenceView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/reference']

  # Expected options to be passed in using the constructor options hash:
  #   parentDataElement - The data element owning the reference being created
  #   referenceTypes - list of reference types (data elements to be created)
  #   cqmValueSets - value sets to display for the data elements to be created
  initialize: ->
    @value = {}
    @value.type = ''

  events:
    'change select[name="referenceType"]': 'handleTypeChange'
    'change select[name="valueset"]': 'handleValueSetChange'
    rendered: ->
      if @value.type == ''
        @$('select[name="referenceType"] > option:first').prop('selected', true)
      else
        @$("select[name=\"referenceType\"] > option[value=\"#{@value.type}\"]").prop('selected', true)
      if !@value?.vs?
        @$('select[name="valueset"] > option:first').prop('selected', true)
      else
        @$("select[name=\"valueset\"] > option[value=\"#{@value.vs}\"]").prop('selected', true)

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @value?.type? && @value?.vs?

  # Event listener for select change event on the main select box for chosing custom or from valueset code
  handleTypeChange: (e) ->
    type = @$('select[name="referenceType"]').val()
    if type != ''
      @value.type = type
    else
      @value.type = null
    @trigger 'valueChanged', @
    @render()

#   Event listener for select change event on the main select box for chosing custom or from valueset code
  handleValueSetChange: (e) ->
    valueSetId = @$('select[name="valueset"]').val()
    @value.vs = valueSetId
    @trigger 'valueChanged', @
    @render()

