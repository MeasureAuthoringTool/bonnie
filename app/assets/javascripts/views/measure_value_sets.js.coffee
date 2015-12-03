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
    
    dataCriteria = []
    supplementalCriteria = []
    summaryValueSets = []
    for sdc in @model.get('source_data_criteria').models
      if sdc.get('code_list_id')
        name = sdc.get('description')
        oid = sdc.get('code_list_id')
        valueSetName = sdc.get('title')
        code_concepts = @sortAndFilterCodes(bonnie.valueSetsByOid[oid].concepts)
        cid = sdc.cid

        for code_concept in code_concepts
          code_concept.display_name_is_long = code_concept.display_name.length > 160

        valueSet = {name: name, oid: oid, valueSetName: valueSetName, code_concepts: code_concepts, cid: cid}

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

    criteriaSets = [{name:"Data Criteria", listOrder: 0, criteria:dataCriteria},
                 {name:"Supplemental Data Elements", listOrder: 1, criteria: supplementalCriteria}]

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

  findOverlappingValueSets: ->
    overlappingValueSets = []
    for {oid: oid1, cid: cid1, codes: codes1, name: name1} in @summaryValueSets
      for {oid: oid2, cid: cid2, codes: codes2, name: name2} in @summaryValueSets
        if oid1 == oid2
          continue
        matchedCodes = []
        for code1 in codes1
          for code2 in codes2
            if code1.code_system_name == code2.code_system_name && code1.code == code2.code
              matchedCodes.push(code1)
        if matchedCodes.length > 0
          cid = cid1 + "_" + cid2
          overlappingValueSets.push({cid: cid, oid1: oid1, oid2: oid2, name1:name1, name2: name2, codes:matchedCodes})
          
    @overlappingValueSets = overlappingValueSets

  events:
    # toggle showing the measure description
    'click .expand.opened': (event) ->
      description_id = event.currentTarget.id
      @$('.' + description_id).animate 'max-height': parseInt(@$('.' + description_id).css('line-height')) * 1 # contract
      @$('#' + description_id).toggleClass('closed opened').html 'Show more <i class="fa fa-caret-down"></i>'
    'click .expand.closed': (event) ->
      description_id = event.currentTarget.id
      if @$('.' + description_id)[0].scrollHeight > @$('.' + description_id).height()
        @$('.' + description_id).animate 'max-height': @$('.' + description_id)[0].scrollHeight # expand
        @$('#' + description_id).toggleClass('closed opened').html 'Show less <i class="fa fa-caret-up"></i>'
      else
        # FIXME: remove this toggle if the description is too short on render rather than on this click.
        @$('#' + description_id).html('Nothing more to show...').fadeOut 2000, -> $(@).remove()
