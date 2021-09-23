# Input view for Any types in composite views
# returns result in a form of { 'type': 'ResourceType', 'vs': 'ValueSetId' }
class Thorax.Views.InputReferenceView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/reference']

  # Expected options to be passed in using the constructor options hash:
  #   parentDataElement - The data element owning the reference being created
  #   referenceTypes - list of reference types (data elements to be created)
  #   cqmValueSets - value sets to display for the data elements to be created
  #   patientBuilder - patient builder to add new patient history elements
  initialize: ->
    @valueSetOptions = @cqmValueSets
    @value = { 'type': null, 'vs': null, isExistingResource: false}
    @existingResources = []
    for dataCriterion in @dataCriteria
      fhirid = dataCriterion.get('dataElement').fhir_resource.id
      resourceType = dataCriterion.get('dataElement').fhir_resource.resourceType
      if fhirid != @parentDataElement.fhir_resource.id && @referenceTypes.includes(resourceType)
        @existingResources.push({
          id: fhirid,
          name: "#{dataCriterion.get('dataElement').description}(...#{fhirid.slice(-6)})",
          type: resourceType
        })

  events:
    'change select[name="referenceType"]': 'handleTypeChange'
    'change select[name="valueset"]': 'handleValueSetChange'
    rendered: ->
      if !@value?.type?
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

  getExistingResourceType: (valueSetId) ->
    @existingResources.find((resource) -> resource.id == valueSetId)?.type

  # Event listener for select change event on the main select box for chosing custom or from valueset code
  handleTypeChange: (e) ->
    type = @$('select[name="referenceType"]').val()
    @showExistingResources = false
    if type == ''
      @value.type = null
    else if type == 'existing_resources'
      @value.type = type
      @valueSetOptions = @existingResources
      @showExistingResources = true
    else
      @value.type = type
      @valueSetOptions = @cqmValueSets
    @trigger 'valueChanged', @
    @render()

#   Event listener for select change event on the main select box for chosing custom or from valueset code
  handleValueSetChange: (e) ->
    valueSetId = @$('select[name="valueset"]').val()
    if valueSetId == '--'
      @value.vs = null
    else if  @value.type == 'existing_resources'
      @value.vs = valueSetId
      @value.type = @getExistingResourceType(valueSetId)
      @value.isExistingResource = true
    else
      @value.vs = valueSetId
    @trigger 'valueChanged', @

  asReferenceType: () ->
    resourceType = @value?.type
    valueSetId = @value?.vs
    fhirid = ''
    if @value?.isExistingResource
      fhirid = valueSetId # for existing resources, fhirid is valueSetId
    else
    # Create new Resource for Reference target
      objectId = cqm.ObjectID().toHexString()
      fhirid = @patientBuilder.addChildCriteria(resourceType, objectId, valueSetId, @parentDataElement)
    # set reference attribute using generated fhirId from new Resource
    reference = new cqm.models.Reference()
    reference.reference = cqm.models.PrimitiveString.parsePrimitive(resourceType + '/' + fhirid)
    reference