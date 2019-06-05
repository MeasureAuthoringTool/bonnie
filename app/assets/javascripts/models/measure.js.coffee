class Thorax.Models.Measure extends Thorax.Model
  idAttribute: '_id'

  populateComponents: ->
    return unless @get('cqmMeasure').get('composite')
    @set 'componentMeasures', new Thorax.Collection @.get('cqmMeasure').get('component_hqmf_set_ids').map(
      (hqmfSetId) -> _.find(bonnie.measures.models, (measure) -> measure.get('cqmMeasure').hqmf_set_id is hqmfSetId)
    )

  initialize: ->
    # Becasue we bootstrap patients we mark them as _fetched, so isEmpty() will be sensible
    @set 'patients', new Thorax.Collections.Patients [], _fetched: true
    @_localIdCache = {}
  parse: (attrs) ->
    thoraxMeasure = {}
    # We don't use cqm measure data criteria since we have to change them for use in the view
    thoraxMeasure.data_criteria = attrs.data_criteria
    thoraxMeasure.cqmMeasure = new cqm.models.Measure(attrs)
    thoraxMeasure._id = thoraxMeasure.cqmMeasure._id.toString()
    if attrs.value_sets?
      thoraxMeasure.cqmValueSets = attrs.value_sets.map (vs) -> new cqm.models.ValueSet(vs)
    else
      thoraxMeasure.cqmValueSets = []

    alphabet = 'abcdefghijklmnopqrstuvwxyz' # for population sub-ids
    populationSets = new Thorax.Collections.PopulationSets [], parent: this

    stratificationPopulations = CQLMeasureHelpers.getStratificationsAsPopulationSets(thoraxMeasure.cqmMeasure.population_sets)
    # thoraxMeasure.population_sets is a combination of mongoose population_sets and mongoose stratifications
    # toObject() removes all mongoose specific fields (ie: '_id' and '_type')
    # This is necessary since our view treats the stratification as a population
    popSetsAndStrats = (thoraxMeasure.cqmMeasure.population_sets.concat stratificationPopulations)
                        .map (popSet) ->
                          if typeof popSet.toObject == 'function'
                            popSet.toObject()
                          else
                            popSet
    for populationSet, index in popSetsAndStrats
      populationSet.sub_id = alphabet[index]
      populationSet.index = index
      # copy population criteria data to population
      for popCode of populationSet.populations
        # preserve the original population code for specifics rationale
        populationSet[popCode] = _(code: popCode).extend(thoraxMeasure.cqmMeasure.population_criteria[popCode])
      populationSets.add new Thorax.Models.PopulationSet(populationSet)

    thoraxMeasure.populations = populationSets
    thoraxMeasure.displayedPopulation = populationSets.first()

    # ignoring versions for diplay names
    oid_display_name_map = {}
    if thoraxMeasure.cqmValueSets
      for valSet in thoraxMeasure.cqmValueSets
        oid_display_name_map[valSet.oid] = valSet.display_name if valSet?.display_name

    for key, data_criteria of thoraxMeasure.data_criteria
      data_criteria.key = key
      # Apply value set display name if one exists for this criteria
      if !data_criteria.variable && oid_display_name_map[data_criteria.codeListId]?
        # For communication criteria we want to include the direction, which is separated from the type with a colon
        if data_criteria.type == 'communications'
          data_criteria.description = data_criteria.description.replace('Communication:', 'Communication')
        data_criteria.description = "#{data_criteria.description.split(':')[0]}: #{oid_display_name_map[data_criteria.codeListId]}"
      if data_criteria.field_values
        data_criteria.references = {}
        for k,field of data_criteria.field_values
          if field.reference?
            data_criteria.references[k] = field
            ref = thoraxMeasure.data_criteria[field.reference]
            field["referenced_criteria"] = ref
            delete data_criteria.field_values[k]

    thoraxMeasure.source_data_criteria = new Thorax.Collections.SourceDataCriteria thoraxMeasure.cqmMeasure.source_data_criteria, parent: this, parse: true
    thoraxMeasure.source_data_criteria.each (criteria) ->
      # Apply value set display name if one exists for this criteria
      if !criteria.get('variable') && oid_display_name_map[criteria.get('codeListId')]?
        # For communication criteria we want to include the direction, which is separated from the type with a colon
        if criteria.get('qdmCategory') == 'communications'
          criteria.set('description', criteria.get('description').replace('Communication:', 'Communication'))
        criteria.set('description', "#{criteria.get('description').split(':')[0]}: #{oid_display_name_map[criteria.get('codeListId')]}")

    thoraxMeasure

  isPopulated: -> @has('source_data_criteria')

  populationCriteria: -> _.intersection(Thorax.Models.Measure.allPopulationCodes, _(@get('cqmMeasure').population_criteria).map (p) -> p.type)

  valueSets: ->
    @get('cqmValueSets')

  hasCode: (code, code_system) ->
    for vs in @valueSets()
      _(vs.concepts).any (c) ->
        c.code == code && c.code_system_name == code_system

  @referencesFor: (criteriaType) ->
    [{key: "Related To", title: "Related To"}]

  @logicFieldsFor: (criteriaType) ->

    # Defines what is included in the drop down menu in the Bonnie Patient Builder for all
    # criteria. The name should correspond with what is the `coded_entry_method` in the `FIELDS`
    # hash in health-data-standards:lib/health-model/data_criteria.rb.
    # TODO: The QDM spec also lists 'recorder' here as a globally included item.
    globalInclusions = ['source', 'health_record_field']

    # Defines what is included in the drop down menu in the Bonnie Patient Builder for a particular
    # criteria. The name should correspond with what is the `coded_entry_method` in the `FIELDS`
    # hash in health-data-standards:lib/hqmf-model/data_criteria.rb.
    typeInclusions =
      adverse_events: ['facility', 'severity', 'type', 'author_datetime']
      allergies_intolerances: ['severity', 'type', 'author_datetime']
      assessments: ['reason', 'method', 'components']
      care_experiences: []
      care_goals: ['target_outcome', 'author_datetime']
      characteristics: []
      communications: ['category', 'sender', 'recipient', 'medium', 'author_datetime']
      conditions: ['anatomical_location', 'ordinality', 'severity', 'author_datetime']
      devices: ['anatomical_location', 'reason', 'author_datetime']
      diagnostic_studies: ['facility', 'method', 'qdm_status', 'result_date_time', 'components', 'reason', 'author_datetime']
      encounters: ['admission_source', 'discharge_disposition', 'facility', 'principal_diagnosis', 'diagnosis', 'reason', 'author_datetime']
      family_history: ['relationship_to_patient']
      immunizations: ['route', 'dose', 'reaction', 'supply', 'active_datetime', 'reason']
      interventions: ['qdm_status', 'reason', 'author_datetime']
      laboratory_tests: ['reference_range_low', 'reference_range_high', 'qdm_status', 'result_date_time', 'components', 'method', 'reason', 'author_datetime']
      medications: ['route', 'dispenser_identifier', 'dose', 'supply', 'administration_timing', 'prescriber_identifier', 'refills', 'setting', 'reason','days_supplied', 'author_datetime']
      participations: []
      physical_exams: ['anatomical_location', 'components', 'method', 'reason', 'author_datetime']
      procedures: ['incision_time', 'anatomical_location', 'ordinality', 'qdm_status', 'components', 'method', 'reason', 'author_datetime']
      provider_care_experiences: []
      provider_characteristics: []
      substances: ['dose', 'route', 'administration_timing', 'supply', 'refills', 'reason', 'author_datetime']
      symptoms: ['severity']

    # start with all field values
    fields = Thorax.Models.Measure.logicFields

    # grab all defined field values, merging global and type-specific specs
    desiredInclusions = _(globalInclusions).union(typeInclusions[criteriaType])

    # check any defined inclusions against the coded_entry_value of each field value
    filteredKeys = (criteria for criteria, value of fields when value['coded_entry_method'] in desiredInclusions)
    fields = _(fields).pick(filteredKeys)

    # we return an array of objects instead of a hash (because we need them sorted), so add the keys to the objects
    _(fields).each (field, key) -> field.key = key

    # return field values sorted by title
    _(fields).sortBy (field) -> field.title

  ###*
  # For CQL measures only. Finds all the localIds in a given statement
  # @public
  # @param {string} libraryName - The library of the statement we want to get the localIds for.
  # @param {string} statementName - The statement name.
  ###
  findAllLocalIdsInStatementByName: (libraryName, statementName) ->
    # if we have this one already in the cache then return the cached result.
    if @_localIdCache[libraryName]?[statementName]?
      return @_localIdCache[libraryName][statementName]
    # if it's not in the cache, build the localId map, put it in the cache and return it.
    else
      @_localIdCache[libraryName] = {} unless @_localIdCache[libraryName]?
      @_localIdCache[libraryName][statementName] = CQLMeasureHelpers.findAllLocalIdsInStatementByName(@.get('cqmMeasure'), libraryName, statementName)
      return @_localIdCache[libraryName][statementName]


class Thorax.Collections.Measures extends Thorax.Collection
  url: '/measures'
  model: Thorax.Models.Measure
  comparator: (m1, m2) ->
    isM1New = m1.get('patients').isEmpty()
    isM2New = m2.get('patients').isEmpty()
    timeDifference = -1 * (new Date(m1.get('cqmMeasure').updated_at) - new Date(m2.get('cqmMeasure').updated_at))
    titleComparison = m1.get('cqmMeasure').title.localeCompare(m2.get('cqmMeasure').title)
    if isM1New and isM2New
      if timeDifference is 0
        return titleComparison
      else
        return timeDifference
    else
      if isM1New
        return -1
      else
        if isM2New
          return 1
        else
          return titleComparison
  populations: ->
    populations = new Thorax.Collections.PopulationSets
    @each (m) -> m.get('populations').each (p) -> populations.add(p)
    populations

  valueSets: ->
    @chain().map((m) -> m.valueSets()?.models or []).flatten().uniq((vs) -> vs.get('oid')).value()

  toOids: ->
    measureToOids = {} # measure hqmf_set_id : valueSet oid
    @each (m) => measureToOids[m.get('cqmMeausre').hqmf_set_id] = m.valueSets().pluck('oid')
    measureToOids

  deepClone: ->
    cloneMeasures = new Thorax.Collections.Measures (@.toJSON())
    cloneMeasures.each (measure) ->
      #Ensure that the population points to the correct measure
      pops = measure.get('populations')
      pops.parent = measure
      measure.set('displayedPopulation', pops.at('0'))
    cloneMeasures
