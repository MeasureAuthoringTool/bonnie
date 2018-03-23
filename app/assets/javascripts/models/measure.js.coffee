class Thorax.Models.Measure extends Thorax.Model
  idAttribute: '_id'
  initialize: ->
    # Becasue we bootstrap patients we mark them as _fetched, so isEmpty() will be sensible
    @set 'patients', new Thorax.Collections.Patients [], _fetched: true
    @_localIdCache = {}
  parse: (attrs) ->
    alphabet = 'abcdefghijklmnopqrstuvwxyz' # for population sub-ids
    populations = new Thorax.Collections.Population [], parent: this
    for population, index in attrs.populations
      population.sub_id = alphabet[index]
      population.index = index
      delete population.id
      # copy population criteria data to population
      for code in @constructor.allPopulationCodes
        if populationCriteriaKey = population[code]
          # preserve the original population code for specifics rationale
          population[code] = _(code: population[code]).extend(attrs.population_criteria[populationCriteriaKey])
      populations.add new Thorax.Models.Population(population)
    attrs.populations = populations
    attrs.displayedPopulation = populations.first()

    # ignoring versions for diplay names
    oid_display_name_map = {}
    for oid, versions of bonnie.valueSetsByOid
      for version, vs of versions
        oid_display_name_map[oid] = vs.display_name if vs?.display_name

    for key, data_criteria of attrs.data_criteria
      data_criteria.key = key
      # Apply value set display name if one exists for this criteria
      if !data_criteria.variable && oid_display_name_map[data_criteria.code_list_id]?
        # For communication criteria we want to include the direction, which is separated from the type with a colon
        if data_criteria.type == 'communications'
          data_criteria.description = data_criteria.description.replace('Communication:', 'Communication')
        data_criteria.description = "#{data_criteria.description.split(':')[0]}: #{oid_display_name_map[data_criteria.code_list_id]}"
      if data_criteria.field_values
        data_criteria.references = {}
        for k,field of data_criteria.field_values
          if field.reference?
            data_criteria.references[k] = field
            ref = attrs.data_criteria[field.reference]
            field["referenced_criteria"] = ref
            delete data_criteria.field_values[k]

    attrs.source_data_criteria = new Thorax.Collections.MeasureDataCriteria _(attrs.source_data_criteria).values(), parent: this
    attrs.source_data_criteria.each (criteria) ->
      # Apply value set display name if one exists for this criteria
      if !criteria.get('variable') && oid_display_name_map[criteria.get('code_list_id')]?
        # For communication criteria we want to include the direction, which is separated from the type with a colon
        if criteria.get('type') == 'communications'
          criteria.set('description', criteria.get('description').replace('Communication:', 'Communication'))
        criteria.set('description', "#{criteria.get('description').split(':')[0]}: #{oid_display_name_map[criteria.get('code_list_id')]}")

    attrs

  isPopulated: -> @has('data_criteria')

  populationCriteria: -> _.intersection(Thorax.Models.Measure.allPopulationCodes, _(@get('population_criteria')).map (p) -> p.type)

  valueSets: ->
    unless @cachedValueSets
      matchingSets = []
      for oid_version in @get('value_set_oid_version_objects')
        if bonnie.valueSetsByOid[oid_version.oid]
          matchingSets.push(bonnie.valueSetsByOid[oid_version.oid][oid_version.version])
      @cachedValueSets = new Thorax.Collection(matchingSets, comparator: (vs) ->
        console.log('WARNING: missing value set') if !vs.get('display_name') && console?
        vs.get('display_name')?.toLowerCase())
    @cachedValueSets

  hasCode: (code, code_system) ->
    @valueSets().any (vs) ->
      _(vs.get('concepts')).any (c) ->
        c.code == code && c.code_system_name == code_system

  @referencesFor: (criteriaType) ->
    [{key: "Related To", title: "Related To"}]

  @logicFieldsFor: (criteriaType) ->

    # Defines what is included in the drop down menu in the Bonnie Patient Builder for all
    # criteria. The name should correspond with what is the `coded_entry_method` in the `FIELDS`
    # hash in health-data-standards:lib/health-model/data_criteria.rb.
    globalInclusions = ['reason', 'source', 'health_record_field']

    # Defines what is included in the drop down menu in the Bonnie Patient Builder for a particular
    # criteria. The name should correspond with what is the `coded_entry_method` in the `FIELDS`
    # hash in health-data-standards:lib/health-model/data_criteria.rb.
    typeInclusions =
      adverse_events: ['facility', 'severity', 'type'] # TODO: (LDY 9/29/2016) we care about "facility location". this appears to be the same as "facility"
      allergies_intolerances: ['severity', 'type']
      assessments: ['method', 'components']
      care_experiences: []
      care_goals: ['target_outcome']
      characteristics: []
      communications: []
      conditions: ['anatomical_structure', 'anatomical_location', 'ordinality', 'severity', 'laterality']
      devices: ['removal_time', 'anatomical_structure']
      diagnostic_studies: ['facility', 'method', 'qdm_status', 'result_date_time', 'components']
      encounters: ['admission_source', 'admit_time', 'discharge_time', 'discharge_disposition', 'facility',
        'transfer_to', 'transfer_to_time', 
        'transfer_from', 'transfer_from_time', 'principal_diagnosis', 'diagnosis']
      family_history: ['relationship_to_patient']
      functional_statuses: []
      immunizations: ['route', 'dose', 'reaction', 'supply']
      interventions: ['anatomical_structure']
      laboratory_tests: ['reference_range_low', 'reference_range_high', 'qdm_status', 'result_date_time', 'components']
      medications: ['route', 'dose', 'reaction', 'supply']
      patient_care_experiences: []
      physical_exams: ['anatomical_structure', 'components']
      preferences: []
      procedures: ['incision_time', 'anatomical_structure', 'anatomical_location', 'ordinality', 'qdm_status', 'components']
      provider_care_experiences: []
      provider_characteristics: []
      risk_category_assessments: ['severity']
      substances: ['dose', 'route', 'frequency', 'reaction', 'supply']
      symptoms: ['ordinality', 'severity']
      system_characteristics: []
      transfers: []

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
      @_localIdCache[libraryName][statementName] = CQLMeasureHelpers.findAllLocalIdsInStatementByName(@, libraryName, statementName)
      return @_localIdCache[libraryName][statementName]


class Thorax.Collections.Measures extends Thorax.Collection
  url: '/measures'
  model: Thorax.Models.Measure
  comparator: (m1, m2) ->
    isM1New = m1.get('patients').isEmpty()
    isM2New = m2.get('patients').isEmpty()
    timeDifference = -1 * (new Date(m1.get('updated_at')) - new Date(m2.get('updated_at')))
    titleComparison = m1.get('title').localeCompare(m2.get('title'))
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
    populations = new Thorax.Collections.Population
    @each (m) -> m.get('populations').each (p) -> populations.add(p)
    populations

  valueSets: ->
    @chain().map((m) -> m.valueSets()?.models or []).flatten().uniq((vs) -> vs.get('oid')).value()

  toOids: ->
    measureToOids = {} # measure hqmf_set_id : valueSet oid
    @each (m) => measureToOids[m.get('hqmf_set_id')] = m.valueSets().pluck('oid')
    measureToOids
    
  deepClone: ->
    cloneMeasures = new Thorax.Collections.Measures (@.toJSON())
    cloneMeasures.each (measure) ->
      #Ensure that the population points to the correct measure
      pops = measure.get('populations')
      pops.parent = measure
      measure.set('displayedPopulation', pops.at('0'))
    cloneMeasures
