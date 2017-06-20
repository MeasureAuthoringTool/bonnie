class Thorax.Views.MeasureValueSets extends Thorax.Views.BonnieView
  template: JST['measure/value_sets/value_sets']

  initialize: ->
    @summaryValueSets = [] # array of {generic value set descriptor, oid, and code}
    @dataCriteria = new Thorax.Collections.ValueSetsCollection([])  # all criteria that aren't supplemental or attributes criteria
    # need sort to show negation rationale after non-negated
    @dataCriteria.comparator = (vs) -> vs.get('name').toLowerCase()
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
  - cidParentObject: object property containing cid
  - oid: code list id
  - displayName: name displayed for this value set oid (aka code_list_id)

  side effect: @fakeIndex incremented for each added criteria
               fakeIndex is used to create fake cid values for non-throax models
               cid is used by the expand/collapse javascript code
  ###
  _createValueSet: (cidParentObject, oid, displayName) ->
    cidParentObject.cid ?= "fake#{@fakeIndex++}"
    cid = cidParentObject.cid

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
        valueSet = @._createValueSet(criteria, criteria.code_list_id, criteria.description)

        # the property values that indicate a supplemental criteria. this list is derived from
        # the human readable html for measures.
        if criteria.property? and criteria.property in ["ethnicity", "gender", "payer", "race"]
          supplementalCriteria.push(valueSet)
        else
          dataCriteria.push(valueSet)

          # if not supplemental criteria, may contain attributes in "value" property
          # we show attributes that have type="CD", a non-empty title, and non-empty code_list_id
          if criteria.value?.type? and criteria.value.type is "CD" and criteria.value.code_list_id?
            displayed_item_name = @model.valueSets().findWhere({oid: criteria.value.code_list_id})?.get('display_name')
            displayed_item_name ?= criteria.value.title
            attributesCriteria.push(@._createValueSet(criteria.value, criteria.value.code_list_id, 'Result: ' + displayed_item_name)) if displayed_item_name

          # attributes are also stored in "field_values" property, under a key, e.g. "PRINCIPAL_DIAGNOSIS"
          if criteria.field_values?
            for key, value of criteria.field_values
              if value.type? and value.type is "CD" and value.code_list_id?
                valueSetDisplayName = @model.valueSets().findWhere({oid: value.code_list_id})?.get('display_name')
                if value.key_title?
                  displayed_item_name = value.key_title
                  displayed_item_name += ': ' + valueSetDisplayName if valueSetDisplayName?
                else if valueSetDisplayName?
                  displayed_item_name = valueSetDisplayName
                else
                  displayed_item_name = value.title
                attributesCriteria.push(@._createValueSet(value, value.code_list_id, displayed_item_name)) if displayed_item_name

          # might contain negation rationale
          if criteria.negation_code_list_id? and criteria.negation
            displayed_item_name = @model.valueSets().findWhere({oid: criteria.negation_code_list_id})?.get('display_name')
            displayed_item_name ?= criteria.description
            displayed_item_name = valueSet.name + " (Not Done: " + displayed_item_name + ")"
            # added another property to hold the negation criteria cid because criteria already has cid
            criteria.negationCidHolder = cid: undefined
            dataCriteria.push(@._createValueSet(criteria.negationCidHolder, criteria.negation_code_list_id, displayed_item_name))

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

    codeToVs = {}
    overlapCodes = {}
    overlapValueSets = {}
    for curValueSet in summaryValueSets
      curValueSet.codes.fullCollection.each (curCode) =>
        workingCode = curCode.get('code') + ":::" + curCode.get('code_system_name')
        vsAndCode = {valueSet: curValueSet, code: curCode}
        if codeToVs[workingCode] == undefined
          codeToVs[workingCode] = []
        else
          for overlap in codeToVs[workingCode]
            overlapKey = overlap['valueSet'].cid + "_" + curValueSet.cid
            if overlapCodes[overlapKey] == undefined
              overlapCodes[overlapKey] = []
            if overlapValueSets[overlapKey] == undefined
              overlapValueSets[overlapKey] = [overlap['valueSet'], curValueSet]
            overlapCodes[overlapKey].push(curCode)
        codeToVs[workingCode].push(vsAndCode)
    
    for overlapKey in Object.keys(overlapValueSets)
      valueSet1 = overlapValueSets[overlapKey][0]
      valueSet2 = overlapValueSets[overlapKey][1]
      matchedCodes = overlapCodes[overlapKey]
      @overlappingValueSets.add
        cid: overlapKey
        codes: new Backbone.PageableCollection(@sortAndFilterCodes(matchedCodes), @pagination_options)
        oid1: valueSet1.oid
        name1: valueSet1.name
        oid2: valueSet2.oid
        name2: valueSet2.name