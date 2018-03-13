class Thorax.Views.PatientDashboardPopover extends Thorax.Views.BonnieView
  template: JST['patient_dashboard/popover']

  initialize: ->
    @population = @measure.get('population_criteria')[@populationKey]
    if @population.preconditions?.length > 0
      preconditionsObject = @population.preconditions[0]
      @rootPrecondition = @findReference preconditionsObject, @dataCriteriaKey
      @parentPrecondition = @findParentOfReference preconditionsObject, @rootPrecondition
      @copyParentPrecondition = jQuery.extend(true, {}, @parentPrecondition) # Deep clone parentPreconditionObject
      @copyParentPrecondition.preconditions = _.filter @copyParentPrecondition.preconditions, (precondition) => precondition.reference == @rootPrecondition.reference
    @aggregator = @population.aggregator
    @variables = new Thorax.Collections.MeasureDataCriteria @getVariables()

  ###
  @returns {Object} returns the reference that matches the data criteria key.
  ###
  findReference: (preconditionsObject, criteria) =>
    if preconditionsObject.reference? && preconditionsObject.reference == criteria
      return preconditionsObject
    if preconditionsObject.preconditions?.length > 0
      for precondition in preconditionsObject.preconditions
        referenceValue = @findReference(precondition, criteria)
        return referenceValue if referenceValue?

  ###
  @returns {Object} returns the parent object of object that containes referencePrecondition
  ###
  findParentOfReference: (preconditionsObject, referencePrecondition) =>
    if preconditionsObject.preconditions?.length > 0
      for precondition in preconditionsObject.preconditions
        if precondition.reference? && precondition.reference == referencePrecondition.reference
          return preconditionsObject
        else if precondition.preconditions?
          referenceValue = @findParentOfReference(precondition, referencePrecondition)
          return referenceValue if referenceValue?

  ###
  @returns {Array} retrieves variables if any exist in the logic statement.
  ###
  getVariables:() =>
    variableDataCriterias = []
    dataCriteriaObjects = []
    # Loop over all children criteria make a list data_criteria that are not null and data_criteria that have variable marked as true.
    for criteria in @allChildrenCriteria
      dataCriteriaObjects.push @measure.get('data_criteria')[criteria] if @measure.get('data_criteria')[criteria]?.variable

    for dataCriteriaObject in dataCriteriaObjects
      if dataCriteriaObject.specific_occurrence_const? # Is this a specific occurence
        specificOccurrenceString = dataCriteriaObject.specific_occurrence_const # speciic_occurnce_const = [data_criteria_key]_"SOURCE"
        sourceDataCriteriaKey = specificOccurrenceString.substring(0, specificOccurrenceString.lastIndexOf("_")); #Removing "_SOURCE" from end of criteria key
      else  # Not a specific occurence
        sourceDataCriteriaKey = dataCriteriaObject.source_data_criteria
      # Select source data criteria down to only data criteria with variable
      # and not specific occurence and where source data criteria matches the
      # specified sourceDataCriteria
      filteredDataCriteria = @measure.get('source_data_criteria').select (dc) =>
        dc.get('variable') && !dc.get('specific_occurrence') &&
        dc.get('source_data_criteria').toUpperCase() == sourceDataCriteriaKey.toUpperCase()
      variableDataCriterias = variableDataCriterias.concat(filteredDataCriteria)
      variableDataCriterias = _.flatten(variableDataCriterias)
    variableDataCriterias
