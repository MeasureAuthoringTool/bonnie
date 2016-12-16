class Thorax.Views.MeasureValueSets extends Thorax.Views.BonnieView
  template: JST['measure/value_sets/value_sets']

  initialize: ->
    @summaryValueSets = [] # array of {generic value set descriptor, oid, and code}
    @dataCriteria = new Thorax.Collections.ValueSetsCollection([], sorting: 'complex')  # all criteria that aren't supplemental criteria
    @supplementalCriteria = new Thorax.Collections.ValueSetsCollection([], sorting: 'complex')  # ethnicity/gender/payer/race criteria
    @overlappingValueSets = new Thorax.Collections.ValueSetsCollection([]) # all value sets that overlap
    @overlappingValueSets.comparator = (vs) -> [vs.get('name1'), vs.get('oid1')]

    # options passed to a Backbone.PageableCollection instance
    @pagination_options =
      mode: 'client'
      state: { pageSize: 10, firstPage: 1, currentPage: 1 }

    @getValueSets() # populates @dataCriteria and @supplementalCriteria
    @findOverlappingValueSets() # populates @overlappingValueSets

  context: ->
    _(super).extend
      overlappingValueSets: @overlappingValueSets
      criteriaSets: [
        { name: "Data Criteria", id: "data_criteria", criteria: @dataCriteria },
        { name: "Supplemental Data Elements", id: "supplemental_criteria", criteria: @supplementalCriteria }
      ]

  getValueSets: ->
    supplementalCriteria = []
    dataCriteria = []

    @model.get('source_data_criteria').each (sdc) =>
      if sdc.get('code_list_id')
        name = sdc.get('description')
        oid = sdc.get('code_list_id')
        cid = sdc.cid

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
        valueSet = { name: name, oid: oid, version: version, codes: codes, cid: cid }

        # the property values that indicate a supplemental criteria. this list is derived from
        # the human readable html for measures.
        if sdc.get('property') in ["ethnicity", "gender", "payer", "race"]
          supplementalCriteria.push(valueSet)
        else
          dataCriteria.push(valueSet)

        # only add value set info summaryValueSets if it isn't there already
        # includes the common name for the value set, the oid, and the codes.
        if _.where(@summaryValueSets, { oid: oid }).length == 0
          nameParts = valueSet.name.split(':')
          name = if nameParts.length > 1 then nameParts[1] else nameParts[0]
          @summaryValueSets.push({ oid: oid, cid: cid, name: name, codes: codes })

    # now that we have all the value sets, filter them
    @supplementalCriteria.add(@filterValueSets(supplementalCriteria))
    @dataCriteria.add(@filterValueSets(dataCriteria))

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
