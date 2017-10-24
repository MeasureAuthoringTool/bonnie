class Thorax.Views.MeasureValueSets extends Thorax.Views.BonnieView
  template: JST['measure/value_sets/value_sets']

  initialize: ->
    @summaryValueSets = [] # array of {generic value set descriptor, oid, and code}
    @terminology = new Thorax.Collections.ValueSetsCollection([], sorting: 'complex') # all value set names, OID, and versions
    @overlappingValueSets = new Thorax.Collections.ValueSetsCollection([]) # all value sets that overlap
    @overlappingValueSets.comparator = (vs) -> [vs.get('name1'), vs.get('oid1')]

    # options passed to a Backbone.PageableCollection instance
    @pagination_options =
      mode: 'client'
      state: { pageSize: 10, firstPage: 1, currentPage: 1 }
    @getValueSets() # populates @terminology
    @findOverlappingValueSets() # populates @overlappingValueSets

  context: ->
    criteriaSetArray = []

    if @terminology.length > 0
      criteriaSetArray.push({ name: "Terminology", id: "terminology", criteria: @terminology })

    _(super).extend
      overlappingValueSets: @overlappingValueSets
      criteriaSets: criteriaSetArray

  getVersionAndCodes: (oid) ->
    oid_version = _.find(@model.get('value_set_oid_version_objects'), (oid_version) -> oid_version.oid == oid)
    if oid_version? && bonnie.valueSetsByOid[oid]?
      version = oid_version.version
      if bonnie.valueSetsByOid[oid][version]?
        codeConcepts = bonnie.valueSetsByOid[oid][version].concepts ? []
        for code in codeConcepts
          code.hasLongDisplayName = code.display_name.length > 160
      else
        version = ''
        codeConcepts = []
    else
      version = ''
      codeConcepts = []

    codes = new Backbone.PageableCollection(@sortAndFilterCodes(codeConcepts), @pagination_options)
    if version.match(/^Draft/)
      version = "Draft"
    [version, codes]

  setSummaryValueSets: (valueSet, oid, cid, name, codes) ->
    # only add value set info summaryValueSets if it isn't there already
    # includes the common name for the value set, the oid, and the codes.
    if _.where(@summaryValueSets, { oid: oid }).length == 0
      nameParts = valueSet.name.split(':')
      name = if nameParts.length > 1 then nameParts[1] else nameParts[0]
      @summaryValueSets.push({ oid: oid, cid: cid, name: name, codes: codes })

  getValueSets: ->
    terminology = []

    if @model.get('elm')
      @model.get('elm').forEach (library) =>
        library.library.valueSets.def.forEach (value_set) =>
          name = value_set.name
          oid = value_set.id
          cid = _.uniqueId('c')

          [version, codes] = @getVersionAndCodes(oid)
          valueSet = { name: name, oid: oid, version: version, codes: codes, cid: cid }

          terminology.push(valueSet)

          @setSummaryValueSets(valueSet, oid, cid, name, codes)

    # now that we have all the value sets, filter them
    @terminology.add(@filterValueSets(terminology))

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

    #Map of codes to the ValueSets they are found in.
    codeToVs = {}
    #Map whose key is a pair of ValueSet CIDs (vs1.cid + "_" + vs2.cid), and whose value is a list of codes shared between them.
    overlapCodes = {}
    #Map whose key is a pair of ValueSet CIDs (vs1.cid + "_" + vs2.cid), and whose value is the pair of valuesets involved.
    overlapValueSets = {}
    #Outer loop iterates over valueSets, inner loop itterates over contained codes.
    #For each code, check codeToVs to see if that code has been seen before; If it hasn't, populate it with an empty array.
    #It its value isn't undefined, that means that that code has been seen before, which means that there is an overlap.
    #Compare the new code against each of the previously seen instances.  A key based on the cids of the involved valuesets is calculated.
    #The code is then added to the relevant entry in overlapCodes.
    #If this is the first time this key is encountered, create a new entry in overlapValueSets to contain the metadata associated with that key.
    #Finally, independent of whether any overlaps were detected, push the code and valueset to codeToVs.
    for curValueSet in summaryValueSets
      curValueSet.codes.fullCollection.each (curCode) =>
        workingCode = curCode.get('code') + ":::" + curCode.get('code_system_name')
        vsAndCode = {valueSet: curValueSet, code: curCode}
        #If the code's entry is undefined, then it has never been seen before.
        #If it isn't undefined, the code has been seen at least once, so there is an overlap.
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
    
    #Users have specfically requested that overlaps should be indicated in both directions.
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
      @overlappingValueSets.add
        cid: valueSet2.cid + "_" + valueSet1.cid
        codes: new Backbone.PageableCollection(@sortAndFilterCodes(matchedCodes), @pagination_options)
        oid1: valueSet2.oid
        name1: valueSet2.name
        oid2: valueSet1.oid
        name2: valueSet1.name
