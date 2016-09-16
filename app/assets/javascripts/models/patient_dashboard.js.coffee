class Thorax.Models.PatientDashboard extends Thorax.Model

  initialize: (@measure, @populations, @populationSet) ->
    # Column names
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

    # Column widths
    @COL_WIDTH_POPULATION = 30
    @COL_WIDTH_META_HUGE = 200
    @COL_WIDTH_META_LARGE = 110
    @COL_WIDTH_META_MEDIUM = 100
    @COL_WIDTH_META_SMALL = 40
    @COL_WIDTH_FREETEXT = 240
    @COL_WIDTH_CRITERIA = 200
    @COL_WIDTH_RESULT = 80

    # Construct a mapping of populations to their data criteria keys
    @criteriaKeysByPopulation = {}
    for population in @populations
      preconditions = @populationSet.get(population)?['preconditions']
      if preconditions
        @criteriaKeysByPopulation[population] = @preconditionCriteriaKeys(preconditions[0]).filter (ck) -> ck != 'MeasurePeriod'
      else
        @criteriaKeysByPopulation[population] = []
    @dataIndices = @getDataIndices(@populations, @criteriaKeysByPopulation)
    @dataCollections = @getDataCollections(@populations, @dataIndices, @criteriaKeysByPopulation)
    @dataInfo = @getDataInfo(@populations, @dataIndices, @dataCollections)

  ###
  @returns {Array} an array of column names in the right order.
  ###
  getDataIndices: (populations, @criteriaKeysByPopulation) =>
    dataIndices = []
    dataIndices.push(@ACTIONS)
    dataIndices.push(@RESULT)
    dataIndices.push(@LAST)
    dataIndices.push(@FIRST)
    for population in populations
      dataIndices.push(@ACTUAL + population)
    for population in populations
      dataIndices.push(@EXPECTED + population)
    dataIndices.push(@DESCRIPTION)
    dataIndices.push(@BIRTHDATE)
    dataIndices.push(@DEATHDATE)
    dataIndices.push(@GENDER)
    for population in populations
      criteria = @criteriaKeysByPopulation[population]
      for criterium in criteria
        dataIndices.push(population + '_' + criterium)
    dataIndices

  ###
  @returns {Array} an array with the top most header columns for the patient
  dashboard table.
  ###
  getDataInfo: (populations, dataIndices, dataCollections) =>
    dataInfo = {}
    # Get the text for all of the data criteria, mapped by data criteria key
    dataCriteriaText = {}
    for reference in Object.keys(@measure.get('data_criteria'))
      dataLogicView = new Thorax.Views.DataCriteriaLogic(reference: reference, measure: @measure)
      dataLogicView.appendTo(@$el)
      dataCriteriaText[dataLogicView.dataCriteria.key] = dataLogicView.$el[0].textContent

    # Include the metadata
    dataInfo[@RESULT] = name: "Result", width: @COL_WIDTH_RESULT
    dataInfo[@LAST] = name: "Last Name", width: @COL_WIDTH_META_MEDIUM
    dataInfo[@FIRST] = name: "First Name", width: @COL_WIDTH_META_MEDIUM
    dataInfo[@ACTIONS] = name: "Options", width: @COL_WIDTH_META_LARGE
    dataInfo[@DESCRIPTION] = name: "Description", width: @COL_WIDTH_FREETEXT
    dataInfo[@BIRTHDATE] = name: "Birthdate", width: @COL_WIDTH_META_HUGE
    dataInfo[@DEATHDATE] = name: "Deathdate", width: @COL_WIDTH_META_HUGE
    dataInfo[@GENDER] = name: "Gender", width: @COL_WIDTH_META_MEDIUM

    for population in populations
      # Include the expected and actual values for each population (IPP/DENOM/etc.)
      dataInfo[@EXPECTED + population] = name: population, width: @COL_WIDTH_POPULATION
      dataInfo[@ACTUAL + population] = name: population, width: @COL_WIDTH_POPULATION
      # Add the data criteria by data criteria key and the data criteria text
      dataCollection = dataCollections[population]
      for item in dataCollection.items
        dataInfo[item] = name: dataCriteriaText[@getRealKey(item)], width: @COL_WIDTH_CRITERIA

    # Add the index from dataIndices for each key
    for key, data of dataInfo
      data.index = dataIndices.indexOf(key)

    return dataInfo

  ###
  @returns {Array} an array of the sub header columns for the patient dashboard
  table.
  ###
  getDataCollections: (populations, dataIndices, criteria_keys_by_population) =>
    dataCollections = {}
    dataCollections[@ACTIONS] = name: "Options", items: [@ACTIONS]
    dataCollections[@RESULT] = name: "Result", items: [@RESULT, @LAST, @FIRST]
    dataCollections[@EXPECTED] = name: "Expected", items: populations.map (p) => @EXPECTED + p
    dataCollections[@ACTUAL] = name: "Actual", items: populations.map (p) => @ACTUAL + p
    dataCollections[@DESCRIPTION] = name: "Description", items: [@DESCRIPTION]
    dataCollections[@METADATA] = name: "Metadata", items: [@BIRTHDATE, @DEATHDATE, @GENDER]
    for population in populations
      dataCollections[population] = name: population, items: criteria_keys_by_population[population].map (c) => population + '_' + c
    for key, dataCollection of dataCollections
      # This grabs the lowest index in the given items
      dataCollection.firstIndex = _.min(dataCollection.items.map (item) -> dataIndices.indexOf(item))
      dataCollection.lastIndex = dataCollection.firstIndex + dataCollection.items.length - 1
    return dataCollections

  ###
  @returns {string} returns the data criteria id
  ###
  getRealKey: (dataKey) =>
    if dataKey in @dataCollections[@EXPECTED].items
      keyValue = dataKey.substring(@EXPECTED.length)
    else if dataKey in @dataCollections[@ACTUAL].items
      keyValue = dataKey.substring(@ACTUAL.length)
    else if dataKey in _.flatten(@populations.map (pop) => @dataCollections[pop].items)
      startIndex = dataKey.indexOf('_') + 1
      keyValue = dataKey.substring(startIndex)
    else
      keyValue = dataKey
    return keyValue

  ###
  @returns {Array} given a data criteria, return the list of all data criteria
  keys referenced within, either through children criteria or temporal
  references; this includes the passed in criteria reference.
  ###
  dataCriteriaChildrenKeys: (criteria_reference) =>
    criteria_keys = [criteria_reference]
    if criteria = @measure.get('data_criteria')[criteria_reference]
      if criteria['children_criteria']?
        criteria_keys = criteria_keys.concat(@dataCriteriaChildrenKeys(childCriteria) for childCriteria in criteria['children_criteria'])
        criteria_keys = _.flatten(criteria_keys)
      if criteria['temporal_references']?
        criteria_keys = criteria_keys.concat(@dataCriteriaChildrenKeys(temporal_reference['reference']) for temporal_reference in criteria['temporal_references'])
        criteria_keys = _.flatten(criteria_keys)

    return criteria_keys

  ###
  @returns {Boolean} returns true if criteria_key has children, false if not.
  ###
  hasChildrenCriteria: (criteria_reference) =>
    criteria_keys = [criteria_reference]
    if criteria = @measure.get('data_criteria')[criteria_reference]
      if criteria['children_criteria']? && criteria['children_criteria']
        return true
      if criteria['temporal_references']? && criteria['temporal_references'][0]['reference'] != 'MeasurePeriod'
        return true
    return false

  ###
  @returns {Array} given a precondition, return the list of all data criteria
  keys referenced within.
  ###
  preconditionCriteriaKeys: (precondition) =>
    if precondition['preconditions'] && precondition['preconditions'].length > 0
      results = (@preconditionCriteriaKeys(precondition) for precondition in precondition['preconditions'])
      results = _.flatten(results)
    else if precondition['reference']
      [precondition['reference']]
    else
      []
