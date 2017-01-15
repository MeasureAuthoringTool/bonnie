class Thorax.Views.MeasureValueSets extends Thorax.Views.BonnieView
  template: JST['measure/value_sets/value_sets']

  initialize: ->
    @summaryValueSets = [] # array of {generic value set descriptor, oid, and code}
    @dataCriteria = new Thorax.Collections.ValueSetsCollection([], sorting: 'complex')  # all criteria that aren't supplemental or attributes criteria
    @supplementalCriteria = new Thorax.Collections.ValueSetsCollection([], sorting: 'complex')  # ethnicity/gender/payer/race criteria
    @attributesCriteria = new Thorax.Collections.ValueSetsCollection([], sorting: 'complex')  # attributes criteria
    @overlappingValueSets = new Thorax.Collections.ValueSetsCollection([]) # all value sets that overlap
    @overlappingValueSets.comparator = (vs) -> [vs.get('name1'), vs.get('oid1')]

    # options passed to a Backbone.PageableCollection instance
    @pagination_options =
      mode: 'client'
      state: { pageSize: 10, firstPage: 1, currentPage: 1 }

    @getValueSets() # populates @dataCriteria, @supplementalCriteria, and @attributesCriteria
    @findOverlappingValueSets() # populates @overlappingValueSets

  context: ->
    _(super).extend
      overlappingValueSets: @overlappingValueSets
      criteriaSets: [
        { name: "Data Criteria", id: "data_criteria", criteria: @dataCriteria },
        { name: "Supplemental Data Elements", id: "supplemental_criteria", criteria: @supplementalCriteria }
        { name: "Attribute Value Sets", id: "attribute_criteria", criteria: @attributesCriteria }
      ]

  ###
  Factory method for value sets
  - criteriaValue: object property containing a code_list_id and cid
  - displayName: name displayed for this value set oid (aka code_list_id)

  side effect: @fakeIndex incremented for each added criteria
               fakeIndex is used to create fake cid values for non-throax models
               cid is used by the expand/collapse javascript code
  ###
  _createValueSet: (criteriaValue, displayName) ->
    oid = criteriaValue.code_list_id
    criteriaValue.cid ?= "fake#{@fakeIndex++}"
    cid = criteriaValue.cid

    if bonnie.valueSetsByOid[oid]?
      version = bonnie.valueSetsByOid[oid].version
      # if it's a date (rather than "Draft"), format the version
      version = moment(version, "YYYYMMDD").format("MM/DD/YYYY") if moment(version, "YYYYMMDD").isValid()
      codeConcepts = bonnie.valueSetsByOid[oid].concepts ? []
      for code in codeConcepts
        code.hasLongDisplayName = code.display_name.length > 160
    else
      version = ''
      codeConcepts = []

    codes = new Backbone.PageableCollection(@sortAndFilterCodes(codeConcepts), @pagination_options)
    valueSet = { name: displayName, oid: oid, version: version, codes: codes, cid: cid }

    # only add value set info summaryValueSets if it isn't there already
    # includes the common name for the value set, the oid, and the codes.
    if _.where(@summaryValueSets, { oid: oid }).length == 0
      nameParts = valueSet.name.split(':')
      summaryName = if nameParts.length > 1 then nameParts[1] else nameParts[0]
      @summaryValueSets.push({ oid: oid, cid: cid, name: summaryName, codes: valueSet.codes })

    valueSet

  getValueSets: ->
    supplementalCriteria = []
    dataCriteria = []
    attributesCriteria = []

    @fakeIndex = 0 # when model is not a Thorax collection, have to generate unique cid based on this index
    _.each @model.get('data_criteria'), (criteria) =>
      if criteria.code_list_id?
        valueSet = @._createValueSet(criteria, criteria.description)

        # the property values that indicate a supplemental criteria. this list is derived from
        # the human readable html for measures.
        if criteria.property? and criteria.property in ["ethnicity", "gender", "payer", "race"]
          supplementalCriteria.push(valueSet)
        else
          dataCriteria.push(valueSet)

          # if not supplemental criteria, may contain attributes in "value" property
          # we show attributes that have type="CD", a non-empty title, and non-empty code_list_id
          if criteria.value?.type? and criteria.value.type is "CD" and criteria.value.title? and criteria.value.code_list_id?
            attributesCriteria.push(@._createValueSet(criteria.value, criteria.value.title))

          # attributes are also stored in "field_values" property, under a key, e.g. "PRINCIPAL_DIAGNOSIS"
          if criteria.field_values?
            for key, value of criteria.field_values
              if value.type? and value.type is "CD" and value.title? and value.code_list_id?
                attributesCriteria.push(@._createValueSet(value, value.title))

    # now that we have all the value sets, filter them
    @supplementalCriteria.add(@filterValueSets(supplementalCriteria))
    @dataCriteria.add(@filterValueSets(dataCriteria))
    @attributesCriteria.add(@filterValueSets(attributesCriteria))

  filterValueSets: (valueSets) ->
    # returns unique (by name and oid) value sets
    _(valueSets).uniq (vs) ->
      (vs.name + vs.oid).replace(/\s/g, "").replace(/[\.,;:-]/g, "").toLowerCase()

  sortAndFilterCodes: (codes) ->
    # returns unique codes sorted by code system and code
    _.chain(codes).sortBy((c) -> c.code_system_name + c.code)
                  .uniq(true, (c) -> c.code_system_name + c.display_name + c.code)
                  .value()

  findOverlappingValueSets: ->
    # determines if one or more codes in a value set are in another value set.
    summaryValueSets = @filterValueSets(@summaryValueSets)

    for valueSet1 in summaryValueSets
      for valueSet2 in _(summaryValueSets).without(valueSet1)
        matchedCodes = []

        # Because codes are pageable, we need to reference the fullCollection to compare all codes
        valueSet1.codes.fullCollection.each (code1) =>
          hasOverlap = valueSet2.codes.fullCollection.some (code2) ->
            overlapsCode = code2.get('code') == code1.get('code')
            overlapsCodeSystem = code2.get('code_system_name') == code1.get('code_system_name')
            return overlapsCode && overlapsCodeSystem

          if hasOverlap then matchedCodes.push(code1)
        if matchedCodes.length > 0
          @overlappingValueSets.add
            cid: valueSet1.cid + "_" + valueSet2.cid
            codes: new Backbone.PageableCollection(@sortAndFilterCodes(matchedCodes), @pagination_options)
            oid1: valueSet1.oid
            name1: valueSet1.name
            oid2: valueSet2.oid
            name2: valueSet2.name
