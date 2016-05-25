class Thorax.Models.PatientDashboard extends Thorax.Model
  @ACTIONS = "actions"
  @OPEN = "open"
  @EDIT = "edit"
  @RESULT = "result"
  @FIRST_NAME = "first"
  @LAST_NAME = "last"
  @NOTES = "notes"
  @BIRTHDATE = "birthdate"
  @DEATHDATE = "deathdate"
  #@RACE = "race"
  #@ETHNICITY = "ethnicity"
  @GENDER = "gender"
  @EXPECTED = "expected"
  @ACTUAL = "actual"
  @NAME = "name"
  @METADATA = "metadata"
    
  @EXPECTED_PREFIX = PatientDashboard.EXPECTED
  @ACTUAL_PREFIX = PatientDashboard.ACTUAL
  
  initialize: (@measure, @populations, @populationSet) ->
    # TODO: I don't think that the width stuff shoudl be in this class. it should be in the view only.
    @COL_WIDTH_NAME = 140
    @COL_WIDTH_POPULATION = 25
    @COL_WIDTH_META = 150
    @COL_WIDTH_FREETEXT = 240
    @COL_WIDTH_CRITERIA = 180
    
    @criteriaKeysByPopulation = {} # "Type" => "Preconditions"
    for population in @populations
      preconditions = @populationSet.get(population)?['preconditions']
      if preconditions
        @criteriaKeysByPopulation[population] = @_preconditionCriteriaKeys(preconditions[0]).filter (ck) -> ck != 'MeasurePeriod'
      else
        @criteriaKeysByPopulation[population] = []
    
    @dataIndices = @getDataIndices(@populations, @criteriaKeysByPopulation)
    @dataCollections = @getDataCollections(@populations, @dataIndices, @criteriaKeysByPopulation)
    @_dataInfo = @getDataInfo(@populations, @dataIndices, @dataCollections)

  getDataIndices: (populations, @criteriaKeysByPopulation) =>
    dataIndices = []
    
    dataIndices.push(PatientDashboard.EDIT)
    dataIndices.push(PatientDashboard.OPEN)
    dataIndices.push(PatientDashboard.FIRST_NAME)
    dataIndices.push(PatientDashboard.LAST_NAME)
    dataIndices.push(PatientDashboard.NOTES)
        
    for population in populations
      dataIndices.push(PatientDashboard.EXPECTED_PREFIX + population)
    for population in populations
      dataIndices.push(PatientDashboard.ACTUAL_PREFIX + population)
    
    dataIndices.push(PatientDashboard.RESULT)
    dataIndices.push(PatientDashboard.BIRTHDATE)
    dataIndices.push(PatientDashboard.DEATHDATE)
    #dataIndices.push(PatientDashboard.RACE)
    #dataIndices.push(PatientDashboard.ETHNICITY)
    dataIndices.push(PatientDashboard.GENDER)
    
    for population in populations
      criteria = @criteriaKeysByPopulation[population]
      for criterium in criteria
        dataIndices.push(population + '_' + criterium)
    
    dataIndices

  getDataInfo: (populations, dataIndices, dataCollections) =>
    dataInfo = {}

    # get the text for all of the data criteria, mapped by data criteria key
    dataCriteriaText = {}
    for reference in Object.keys(@measure.get('data_criteria'))
      dataLogicView = new Thorax.Views.DataCriteriaLogic(reference: reference, measure: @measure)
      dataLogicView.appendTo(@$el)
      dataCriteriaText[dataLogicView.dataCriteria.key] = dataLogicView.$el[0].outerText

    # include the metadata
    dataInfo[PatientDashboard.EDIT] = { name: "", width: 45 }
    dataInfo[PatientDashboard.OPEN] = { name: "", width: 73 }
    dataInfo[PatientDashboard.RESULT] = { name: "Passes?", width: @COL_WIDTH_META }
    dataInfo[PatientDashboard.FIRST_NAME] = { name: "First Name", width: @COL_WIDTH_NAME }
    dataInfo[PatientDashboard.LAST_NAME] = { name: "Last Name", width: @COL_WIDTH_NAME }
    dataInfo[PatientDashboard.NOTES] = { name: "Description", width: @COL_WIDTH_FREETEXT }
    dataInfo[PatientDashboard.BIRTHDATE] = { name: "Birthdate", width: @COL_WIDTH_META }
    dataInfo[PatientDashboard.DEATHDATE] = { name: "Deathdate", width: @COL_WIDTH_META }
    #dataInfo[PatientDashboard.RACE] = { name: "Race", width: @COL_WIDTH_META }
    #dataInfo[PatientDashboard.ETHNICITY] = { name: "Ethnicity", width: @COL_WIDTH_META }
    dataInfo[PatientDashboard.GENDER] = { name: "Gender", width: @COL_WIDTH_META }

    for population in populations
      # include the expected and actual values for each population (IPP/DENOM/etc.)
      dataInfo[PatientDashboard.EXPECTED_PREFIX + population] = { name: population, width: @COL_WIDTH_POPULATION }
      dataInfo[PatientDashboard.ACTUAL_PREFIX + population] = { name: population, width: @COL_WIDTH_POPULATION }
      
      # add the data criteria by data criteria key and the data criteria text
      dataCollection = dataCollections[population]
      for item in dataCollection.items
        dataInfo[item] = { name: dataCriteriaText[@getRealKey(item)], width: @COL_WIDTH_CRITERIA }

    # add the index from dataIndices for each key
    for key, data of dataInfo
      data.index = dataIndices.indexOf(key)

    return dataInfo

  getDataCollections: (populations, dataIndices, criteria_keys_by_population) =>
    dataCollections = {}
    dataCollections[PatientDashboard.ACTIONS] = {name: "", items: [PatientDashboard.EDIT, PatientDashboard.OPEN] }
    dataCollections[PatientDashboard.NOTES] = {name: "", items: [PatientDashboard.NOTES] }
    dataCollections[PatientDashboard.NAME] = { name: "Names", items: [PatientDashboard.FIRST_NAME, PatientDashboard.LAST_NAME] }
    dataCollections[PatientDashboard.EXPECTED] = { name: "Expected", items: PatientDashboard.EXPECTED_PREFIX + pop for pop in populations }
    dataCollections[PatientDashboard.ACTUAL] = { name: "Actual", items: PatientDashboard.ACTUAL_PREFIX + pop for pop in populations }
    #dataCollections[PatientDashboard.METADATA] = {name: "Metadata", items: [PatientDashboard.RESULT, PatientDashboard.BIRTHDATE, PatientDashboard.DEATHDATE, PatientDashboard.RACE, PatientDashboard.ETHNICITY, PatientDashboard.GENDER]}
    dataCollections[PatientDashboard.METADATA] = {name: "Metadata", items: [PatientDashboard.RESULT, PatientDashboard.BIRTHDATE, PatientDashboard.DEATHDATE, PatientDashboard.GENDER]}
    
    for population in populations
      dataCollections[population] = { name: population, items: population + '_' + criteria for criteria in criteria_keys_by_population[population] }
    
    for key, dataCollection of dataCollections
      dataCollection.firstIndex = Math.min (dataIndices.indexOf(item) for item in dataCollection.items)...
      dataCollection.lastIndex = dataCollection.firstIndex + dataCollection.items.length - 1
    
    return dataCollections

  getWidth: (dataKey) =>
    @_dataInfo[dataKey].width
      
  getIndex: (dataKey) =>
    @_dataInfo[dataKey].index
  
  getName: (dataKey) =>
    @_dataInfo[dataKey].name
  
  isIndexInCollection: (index, collectionKey) =>
    index >= @dataCollections[collectionKey].firstIndex && index <= @dataCollections[collectionKey].lastIndex
  
  isIndexDataCriteria: (index) =>
    for population in @populations
      return true if @isIndexInCollection(index, population)
    return false
  
  getCollectionStartIndex: (collectionKey) =>
    @dataCollections[collectionKey].firstIndex

  getCollectionLastIndex: (collectionKey) =>
    @dataCollections[collectionKey].lastIndex

  criteriaStartIndex: =>
    if !@_criteriaStartIndex
      for pop in @populations
        if @dataCollections[pop].items.length > 0
          @_criteriaStartIndex = @dataCollections[pop].firstIndex
          break
    @_criteriaStartIndex
  
  isExpectedValue: (dataKey) =>
    dataKey in @dataCollections[PatientDashboard.EXPECTED].items
    
  isActualValue: (dataKey) =>
    dataKey in @dataCollections[PatientDashboard.ACTUAL].items
    
  isCriteria: (dataKey) =>
    isCriteria = false
    for pop in @populations
      isCriteria = dataKey in @dataCollections[pop].items
      break if isCriteria
    isCriteria
    
  getCriteriaPopulation: (dataKey) =>
    if @isCriteria(dataKey)
      result = dataKey.substring(0, dataKey.indexOf('_'))

    result
  
  getRealKey: (dataKey) =>
    if @isExpectedValue(dataKey)
      keyValue = dataKey.substring(PatientDashboard.EXPECTED.length)
    else if @isActualValue(dataKey)
      keyValue = dataKey.substring(PatientDashboard.ACTUAL.length)
    else if @isCriteria(dataKey)
      startIndex = dataKey.indexOf('_') + 1
      keyValue = dataKey.substring(startIndex)
    else
      keyValue = dataKey

    return keyValue
    
  # Given a data criteria, return the list of all data criteria keys referenced within, either through
  # children criteria or temporal references; this includes the passed in criteria reference
  _dataCriteriaChildrenKeys: (criteria_reference) =>
    criteria_keys = [criteria_reference]
    if criteria = @measure.get('data_criteria')[criteria_reference]
      if criteria['children_criteria']?
        criteria_keys = criteria_keys.concat(@_dataCriteriaChildrenKeys(criteria) for criteria in criteria['children_criteria'])
        criteria_keys = flatten(criteria_keys)
      if criteria['temporal_references']?
        criteria_keys = criteria_keys.concat(@_dataCriteriaChildrenKeys(temporal_reference['reference']) for temporal_reference in criteria['temporal_references'])
        criteria_keys = flatten(criteria_keys)

    return criteria_keys

  # Given a precondition, return the list of all data criteria keys referenced within
  _preconditionCriteriaKeys: (precondition) =>
    if precondition['preconditions'] && precondition['preconditions'].length > 0
      results = (@_preconditionCriteriaKeys(precondition) for precondition in precondition['preconditions'])
      results = flatten(results)
    else if precondition['reference']
      @_dataCriteriaChildrenKeys(precondition['reference'])
    else
      []
      
# TODO: is there a way to write the above so that this isn't even needed?
#TODO Make this coffeescript. Or use underscore.js
  `function flatten(arr) {
    const flat = [].concat(...arr)
    return flat.some(Array.isArray) ? flatten(flat) : flat;
  }`
