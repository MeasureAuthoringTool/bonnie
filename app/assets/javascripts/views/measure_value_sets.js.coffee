class Thorax.Views.MeasureValueSets extends Thorax.Views.BonnieView

  template: JST['measure/value_sets']

  initialize: ->
    @getValueSets()
    @findOverlappingValueSets()

  context: ->
    _(super).extend
      criteriaSets: @criteriaSets
      overlappingValueSets: @overlappingValueSets

  getValueSets: ->
    # the property values that indicate a supplemental criteria. this list is derived from
    # the human readable html for measures.
    supplementalCriteriaProperties = ["ethnicity", "gender", "payer", "race"]

    dataCriteria = [] # all criteria that aren't supplemental criteria
    supplementalCriteria = [] # ethnicity/gender/payer/race criteria
    summaryValueSets = [] # array of {generic value set descriptor, oid, and code}

    for sdc in @model.get('source_data_criteria').models
      if sdc.get('code_list_id')
        name = sdc.get('description')
        oid = sdc.get('code_list_id')
        valueSetName = sdc.get('title')
        if bonnie.valueSetsByOid[oid]?
          version = bonnie.valueSetsByOid[oid].version
          code_concepts = @sortAndFilterCodes(bonnie.valueSetsByOid[oid].concepts)
        else
          version = ''
          code_concepts = []
        cid = sdc.cid

        for code_concept in code_concepts
          code_concept.display_name_is_long = code_concept.display_name.length > 160

        valueSet = {name: name, oid: oid, valueSetName: valueSetName, version: version, code_concepts: code_concepts, cid: cid}

        # only add value set info summaryValueSets if it isn't there already
        # includes the common name for the value set, the oid, and the codes.
        if _.where(summaryValueSets, {oid: oid}).length == 0
          nameParts = valueSet.name.split(':')
          if nameParts.length > 1
            name = nameParts[1]
          else
            name = nameParts[0]
          summaryValueSets.push({oid: oid, cid: cid, name: name, codes:code_concepts})

        if sdc.get('property') in supplementalCriteriaProperties
          supplementalCriteria.push(valueSet)
        else
          dataCriteria.push(valueSet)

    dataCriteria = @sortAndFilterValueSets(dataCriteria)
    supplementalCriteria = @sortAndFilterValueSets(supplementalCriteria)
    summaryValueSets = _.chain(summaryValueSets).sortBy((valueSet) => valueSet.oid).value()

    criteriaSets = [{name:"Data Criteria", id:"data_criteria", criteria:dataCriteria},
                    {name:"Supplemental Data Elements", id:"supplemental_criteria", criteria: supplementalCriteria}]

    @criteriaSets = criteriaSets
    @summaryValueSets = summaryValueSets

  sortAndFilterValueSets: (valueSets) ->
    _.chain(valueSets).sortBy((valueSet) => valueSet.name)
                      .sortBy((valueSet) => valueSet.valueSetName)
                      .sortBy((valueSet) => valueSet.oid)
                      .uniq(true, (valueSet) =>
                        (valueSet.name + valueSet.valueSetName + valueSet.oid).replace(/\s/g, "")
                                                                              .replace(/[\.,;:-]/g, "")
                                                                              .toLowerCase())
                      .value()

  sortAndFilterCodes: (codes) ->
    _.chain(codes).sortBy((code) => code.display_name)
                  .sortBy((code) => code.code_system_name)
                  .uniq(true, (code) =>
                    code.code_system_name + code.display_name + code.code)
                  .value()

  # determines if one or more codes in a value set are equal to codes in another value set.
  findOverlappingValueSets: ->
    overlappingValueSets = []
    for valueSet1 in @summaryValueSets
      for valueSet2 in @summaryValueSets
        if valueSet1.oid == valueSet2.oid
          continue
        matchedCodes = []
        for code1 in valueSet1.codes
          for code2 in valueSet2.codes
            if code1.code_system_name == code2.code_system_name && code1.code == code2.code
              matchedCodes.push(code1)
        if matchedCodes.length > 0
          cid = valueSet1.cid + "_" + valueSet2.cid
          overlappingValueSets.push({cid: cid, codes:matchedCodes,\
                                     oid1: valueSet1.oid, name1:valueSet1.name,\
                                     oid2: valueSet2.oid, name2: valueSet2.name})

    @overlappingValueSets = overlappingValueSets

  events:
    # toggle showing the code description
    'click .expand': (event) -> @toggleDescription(event.currentTarget.id)

  toggleDescription: (expand_id) ->
    description_id = expand_id.replace('expand', 'description')
    @$('#' + expand_id).toggleClass('closed opened')

    if @$('#' + description_id)[0].scrollHeight > @$('#' + description_id).height()
      @$('#' + description_id).animate
        'max-height': @$('#' + description_id)[0].scrollHeight # expand
      @$('#' + expand_id).html 'Show less <i class="fa fa-caret-up"></i>'
    else
      @$('#' + description_id).animate
        'max-height': parseInt(@$('#' + description_id).css('line-height')) # contracts
      @$('#' + expand_id).html 'Show more <i class="fa fa-caret-down"></i>'
