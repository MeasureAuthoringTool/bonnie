class Thorax.Models.PatientDashboard extends Thorax.Model
  @ACTIONS = "actions"
  @RESULT = "result"
  @DESCRIPTION = "description"
  @BIRTHDATE = "birthdate"
  @DEATHDATE = "deathdate"
  @FIRST = "first"
  @LAST = "last"
  @GENDER = "gender"
  @EXPECTED = "expected"
  @ACTUAL = "actual"
  @METADATA = "metadata"

  @EXPECTED_PREFIX = PatientDashboard.EXPECTED
  @ACTUAL_PREFIX = PatientDashboard.ACTUAL

  initialize: (@measure, @populations, @populationSet) ->
    # TODO: I don't think that the width stuff shoudl be in this class. it should be in the view only.
    @COL_WIDTH_POPULATION = 30
    @COL_WIDTH_META_LARGE = 100
    @COL_WIDTH_META_MEDIUM = 100
    @COL_WIDTH_META_SMALL = 40
    @COL_WIDTH_FREETEXT = 240
    @COL_WIDTH_CRITERIA = 200
    @COL_WIDTH_RESULT = 80

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

  getHorizontalScrollOffset: ->
    @COL_WIDTH_RESULT + @COL_WIDTH_META_MEDIUM*2 + @COL_WIDTH_META_SMALL + @COL_WIDTH_POPULATION*(@populations.length+1) + 15


  getDataIndices: (populations, @criteriaKeysByPopulation) =>
    dataIndices = []
    dataIndices.push(PatientDashboard.ACTIONS)
    dataIndices.push(PatientDashboard.RESULT)
    dataIndices.push(PatientDashboard.LAST)
    dataIndices.push(PatientDashboard.FIRST)
    for population in populations
      dataIndices.push(PatientDashboard.ACTUAL_PREFIX + population)
    for population in populations
      dataIndices.push(PatientDashboard.EXPECTED_PREFIX + population)
    dataIndices.push(PatientDashboard.DESCRIPTION)
    dataIndices.push(PatientDashboard.BIRTHDATE)
    dataIndices.push(PatientDashboard.DEATHDATE)
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
      dataCriteriaText[dataLogicView.dataCriteria.key] = dataLogicView.$el[0].textContent

    # include the metadata
    dataInfo[PatientDashboard.RESULT] = { name: "Result", width: @COL_WIDTH_RESULT }
    dataInfo[PatientDashboard.LAST] = { name: "Last Name", width: @COL_WIDTH_META_MEDIUM }
    dataInfo[PatientDashboard.FIRST] = { name: "First Name", width: @COL_WIDTH_META_MEDIUM }
    dataInfo[PatientDashboard.ACTIONS] = { name: "Options", width: @COL_WIDTH_META_SMALL }
    dataInfo[PatientDashboard.DESCRIPTION] = { name: "Description", width: @COL_WIDTH_FREETEXT }
    dataInfo[PatientDashboard.BIRTHDATE] = { name: "Birthdate", width: @COL_WIDTH_META_LARGE }
    dataInfo[PatientDashboard.DEATHDATE] = { name: "Deathdate", width: @COL_WIDTH_META_LARGE }
    dataInfo[PatientDashboard.GENDER] = { name: "Gender", width: @COL_WIDTH_META_MEDIUM }

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
    dataCollections[PatientDashboard.ACTIONS] = {name: "Options", items: [PatientDashboard.ACTIONS] }
    dataCollections[PatientDashboard.RESULT] = {name: "Result", items: [PatientDashboard.RESULT, PatientDashboard.LAST, PatientDashboard.FIRST] }
    dataCollections[PatientDashboard.EXPECTED] = { name: "Expected", items: PatientDashboard.EXPECTED_PREFIX + pop for pop in populations }
    dataCollections[PatientDashboard.ACTUAL] = { name: "Actual", items: PatientDashboard.ACTUAL_PREFIX + pop for pop in populations }
    dataCollections[PatientDashboard.DESCRIPTION] = {name: "Description", items: [PatientDashboard.DESCRIPTION] }
    dataCollections[PatientDashboard.METADATA] = {name: "Metadata", items: [PatientDashboard.BIRTHDATE, PatientDashboard.DEATHDATE, PatientDashboard.GENDER]}

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
        criteria_keys = _.flatten(criteria_keys)
      if criteria['temporal_references']?
        criteria_keys = criteria_keys.concat(@_dataCriteriaChildrenKeys(temporal_reference['reference']) for temporal_reference in criteria['temporal_references'])
        criteria_keys = _.flatten(criteria_keys)

    return criteria_keys

  # Given a precondition, return the list of all data criteria keys referenced within
  _preconditionCriteriaKeys: (precondition) =>
    if precondition['preconditions'] && precondition['preconditions'].length > 0
      results = (@_preconditionCriteriaKeys(precondition) for precondition in precondition['preconditions'])
      results = _.flatten(results)
    else if precondition['reference']
      [precondition['reference']]
    else
      []

  ###
  @returns {Object}  Children criteria keys and criteria_text
  ###
  getChildrenCriteria: (criteria_key) =>
    if criteria_key?
      children_criteria = @_dataCriteriaChildrenKeys(criteria_key)
      children_criteria = children_criteria.filter (ck) -> ck != 'MeasurePeriod'
      dataCriteriaViewMap = {}
      for reference in children_criteria
        if reference != criteria_key # We want to ignore the data criteria itself when populating map.
          dataLogicView = new Thorax.Views.DataCriteriaLogic(reference: reference, measure: @measure)
          dataLogicView.appendTo(@$el)
          dataCriteriaViewMap[reference] = dataLogicView.$el[0].textContent
      dataCriteriaViewMap
