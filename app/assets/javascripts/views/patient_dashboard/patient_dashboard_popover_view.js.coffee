class Thorax.Views.PatientDashboardPopover extends Thorax.Views.BonnieView
  template: JST['patient_dashboard/popover']

  population_map:
    'IPP': 'Initial Population'
    'STRAT': 'Stratification'
    'DENOM': 'Denominator'
    'NUMER': 'Numerator'
    'NUMEX': 'Numerator Exclusions'
    'DENEXCEP': 'Denominator Exceptions'
    'DENEX': 'Denominator Exclusions'
    'MSRPOPL': 'Measure Population'
    'OBSERV': 'Measure Observations'
    'MSRPOPLEX': 'Measure Population Exclusions'
  aggregator_map:
    'MEAN':'Mean of'
    'MEDIAN':'Median of'

  initialize: ->
    @population = @measure.get('population_criteria')[@populationKey]
    if @population.preconditions?.length > 0
      preconditionsObject = @population.preconditions[0]
      @rootPrecondition = @findReference(preconditionsObject, @dataCriteriaKey)
    @aggregator = @population.aggregator
    @variables = new Thorax.Collections.MeasureDataCriteria @getVariables()

  ###
  @returns {string} returns the reference that matches the data criteria key.
  ###
  findReference: (preconditionsObject, criteria) =>
    if preconditionsObject.reference? && preconditionsObject.reference == criteria
      return preconditionsObject
    if preconditionsObject.preconditions?.length > 0
      for precondition in preconditionsObject.preconditions
        referenceValue = @findReference(precondition, criteria)
        return referenceValue if referenceValue?

  ###
  @returns {Array} retrieves variables if any exist in the logic statement.
  ###
  getVariables:() =>
    dataCriteriaObject = @measure.get('data_criteria')[@dataCriteriaKey]
    variableDataCriterias = []
    dataCriteriaObjects = []
    for criteria in @allChildrenCriteria
      dataCriteriaObjects.push @measure.get('data_criteria')[criteria] if @measure.get('data_criteria')[criteria]?
    for dataCriteriaObject in dataCriteriaObjects
      if dataCriteriaObject?.variable
        if dataCriteriaObject.specific_occurrence_const?
          specificOccurrenceString = dataCriteriaObject.specific_occurrence_const
          sourceDataCriteriaKey = specificOccurrenceString.substring(0, specificOccurrenceString.lastIndexOf("_")); #Removing "_SOURCE" from end of criteria key
        else
          sourceDataCriteriaKey = dataCriteriaObject.source_data_criteria
        allMeasureDataCriterias = @measure.get('source_data_criteria').select (dc) -> dc.get('variable') && !dc.get('specific_occurrence')
        measureDataCriterias = allMeasureDataCriterias.filter (measureDataCriteria) -> measureDataCriteria.get('source_data_criteria').toUpperCase() == sourceDataCriteriaKey.toUpperCase()
        variableDataCriterias = variableDataCriterias.concat(measureDataCriterias)
        variableDataCriterias = _.flatten(variableDataCriterias)
    variableDataCriterias

  ###
  @returns {string} returns the full name for a population given an abbreviation
  ###
  translate_population: (code) ->
    @population_map[code]

  ###
  @returns {string} returns the full name of an aggregation given a type
  ###
  translate_aggregator: (code) ->
    @aggregator_map[code]
