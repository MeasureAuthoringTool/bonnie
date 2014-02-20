class Thorax.Models.Measure extends Thorax.Model
  idAttribute: '_id'
  initialize: ->
    @set 'patients', new Thorax.Collections.Patients
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

    for key, data_criteria of attrs.data_criteria
      data_criteria.key = key

    attrs.source_data_criteria = new Thorax.Collections.MeasureDataCriteria _(attrs.source_data_criteria).values(), parent: this
    attrs

  isPopulated: -> @has('data_criteria')

  populationCriteria: -> _.intersection(Thorax.Models.Measure.allPopulationCodes, _(@get('population_criteria')).keys())

  valueSets: ->
    unless @cachedValueSets
      matchingSets = (bonnie.valueSetsByOid[oid] for oid in @get('value_set_oids'))
      @cachedValueSets = new Thorax.Collection(matchingSets, comparator: (vs) -> vs.get('display_name').toLowerCase())
    @cachedValueSets

  @logicFieldsFor: (criteriaType) ->

    # Define field values for all criteria types
    globalInclusions = ['anatomical_structure', 'cumulative_medication_duration', 'dose',
    'frequency', 'incision_time', 'length_of_stay', 'ordinality', 'reason', 'removal_time',
    'route', 'severity', 'source', 'start_date', 'end_date']

    # Define criteria type-specific field values
    typeInclusions =
      care_goals: []
      characteristics: []
      communications: []
      conditions: []
      devices: []
      diagnostic_studies: []
      encounters: ['admit_time', 'discharge_time', 'discharge_disposition', 'facility',
        'facility_arrival', 'facility_departure', 'transfer_to', 'transfer_from']
      functional_statuses: []
      interventions: []
      laboratory_tests: []
      medications: []
      patient_care_experiences: []
      physical_exams: []
      preferences: []
      procedures: []
      provider_care_experiences: []
      provider_characteristics: []
      risk_category_assessments: []
      substances: []
      symptoms: []
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

