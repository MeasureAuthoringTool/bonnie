class Thorax.Models.PatientDashboard extends Thorax.Model

  initialize: (@measure, @populations, @populationSet, @widths) ->
    # Column names
    @columnNames =
      actions: "actions"
      result: "result"
      description: "description"
      birthdate: "birthdate"
      deathdate: "deathdate"
      first: "first"
      last: "last"
      gender: "gender"
      expected: "expected"
      actual: "actual"
      metadata: "metadata"

    # Construct a mapping of populations to their data criteria keys
    # Example:  { IPP:['key', 'key'], DENOM: ['key'] }
    @criteriaKeysByPopulation = {}
    for population in @populations
      precondition = _.first @populationSet.get(population)?['preconditions']
      if precondition
        @criteriaKeysByPopulation[population] = @preconditionCriteriaKeys(precondition).filter (ck) -> ck != 'MeasurePeriod'
      else
        @criteriaKeysByPopulation[population] = []

    # An array of column names in the right order
    @dataIndices = @getDataIndices()
    # An array of the sub header columns for the patient dashboard table.
    @dataCollections = @getDataCollections()
    # An array with the top most header columns for the patient dashboard table.
    @dataInfo = @getDataInfo()

  ###
  @returns {Array} an array of column names/keys in the right order.
  Note: If the order of the columns change, also change the order in
  MeasurePopulationPatientDashboard View, in the function getTableColumns().
  ###
  getDataIndices: () =>
    dataIndices = []
    dataIndices.push(@columnNames.actions)
    dataIndices.push(@columnNames.result)
    dataIndices.push(@columnNames.last)
    dataIndices.push(@columnNames.first)
    for population in @populations
      dataIndices.push(@columnNames.actual + population)
    for population in @populations
      dataIndices.push(@columnNames.expected + population)
    dataIndices.push(@columnNames.description)
    dataIndices.push(@columnNames.birthdate)
    dataIndices.push(@columnNames.deathdate)
    dataIndices.push(@columnNames.gender)
    for population in @populations
      criteria = @criteriaKeysByPopulation[population]
      for criterium in criteria
        dataIndices.push(population + '_' + criterium)
    dataIndices

  ###
  @returns {Object} an object (mapping) containing metadata information about
  each column. The metadata information includes the name, the width, and the
  column index.
  ###
  getDataInfo: () =>
    dataInfo = {}
    # Get the text for all of the data criteria, mapped by data criteria key
    dataCriteriaText = {}
    for reference in Object.keys(@measure.get('data_criteria'))
      dataLogicView = new Thorax.Views.DataCriteriaLogic(reference: reference, measure: @measure)
      # Appends to DOM in order to grab information from the view.
      dataLogicView.appendTo(@$el)
      dataCriteriaText[dataLogicView.dataCriteria.key] = dataLogicView.$el[0].textContent

    # Include the metadata
    dataInfo[@columnNames.result] = name: "Result", width: @widths.result
    dataInfo[@columnNames.last] = name: "Last Name", width: @widths.meta_medium
    dataInfo[@columnNames.first] = name: "First Name", width: @widths.meta_medium
    dataInfo[@columnNames.actions] = name: "Options", width: @widths.meta_large
    dataInfo[@columnNames.description] = name: "Description", width: @widths.freetext
    dataInfo[@columnNames.birthdate] = name: "Birthdate", width: @widths.meta_huge
    dataInfo[@columnNames.deathdate] = name: "Deathdate", width: @widths.meta_huge
    dataInfo[@columnNames.gender] = name: "Gender", width: @widths.meta_medium

    for population in @populations
      # Include the expected and actual values for each population (IPP/DENOM/etc.)
      dataInfo[@columnNames.expected + population] = name: population, width: @widths.population
      dataInfo[@columnNames.actual + population] = name: population, width: @widths.population
      # Add the data criteria by data criteria key and the data criteria text
      dataCollection = @dataCollections[population]
      for item in dataCollection.items
        dataInfo[item] = name: dataCriteriaText[@stripLeadingToken(item)], width: @widths.criteria

    # Add the index from dataIndices for each key
    for key, data of dataInfo
      data.index = @dataIndices.indexOf(key)

    return dataInfo

  ###
  @returns {Object} an object (mapping) of the sub header columns for the
  patient dashboard table.
  ###
  getDataCollections: () =>
    dataCollections = {}
    dataCollections[@columnNames.actions] = name: "Options", items: [@columnNames.actions]
    dataCollections[@columnNames.result] = name: "Result", items: [@columnNames.result, @columnNames.last, @columnNames.first]
    dataCollections[@columnNames.expected] = name: "Expected", items: @populations.map (p) => @columnNames.expected + p
    dataCollections[@columnNames.actual] = name: "Actual", items: @populations.map (p) => @columnNames.actual + p
    dataCollections[@columnNames.description] = name: "Description", items: [@columnNames.description]
    dataCollections[@columnNames.metadata] = name: "Metadata", items: [@columnNames.birthdate, @columnNames.deathdate, @columnNames.gender]
    for population in @populations
      dataCollections[population] = name: population, items: @criteriaKeysByPopulation[population].map (c) => population + '_' + c
    for key, dataCollection of dataCollections
      # This grabs the lowest index in the given items
      dataCollection.firstIndex = _.min(dataCollection.items.map (item) => @dataIndices.indexOf(item))
      dataCollection.lastIndex = dataCollection.firstIndex + dataCollection.items.length - 1
    return dataCollections

  ###
  @returns {string} strips an artificially added token from a key
  ###
  stripLeadingToken: (key) =>
    if /expected/i.test(key)
      key.replace 'expected', ''
    else if /actual/i.test(key)
      key.replace 'actual', ''
    else if /_/i.test(key)
      key.substring(key.indexOf("_") + 1)
    else
      key

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
