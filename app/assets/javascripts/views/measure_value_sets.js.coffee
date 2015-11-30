class Thorax.Views.MeasureValueSets extends Thorax.Views.BonnieView

  template: JST['measure/value_sets']

  context: ->
    # the property values that indicate a supplemental criteria. this list is derived from 
    # the human readable html for measures.
    supplementalCriteriaProperties = ["ethnicity", "gender", "payer", "race"]
    
    dataCriteria = []
    supplementalCriteria = []
    for sdc in @model.get('source_data_criteria').models
      if sdc.get('code_list_id')
        name = sdc.get('description')
        oid = sdc.get('code_list_id')
        valueSetName = sdc.get('title')
        code_concepts = @sortAndFilterCodes(bonnie.valueSetsByOid[oid].concepts)
        cid = sdc.cid

        criteria = {name: name, oid: oid, valueSetName: valueSetName, code_concepts: code_concepts, cid: cid}

        if sdc.get('property') in supplementalCriteriaProperties
          supplementalCriteria.push(criteria)
        else
          dataCriteria.push(criteria)

    dataCriteria = @sortAndFilterCriteria(dataCriteria)
    supplementalCriteria = @sortAndFilterCriteria(supplementalCriteria)

    valueSets = [{name:"Data Criteria", listOrder: 0, criteria:dataCriteria},
                 {name:"Supplemental Data Elements", listOrder: 1, criteria: supplementalCriteria}]
    valueSets = _.chain(valueSets).sortBy((vs) => vs.listOrder).value()

    _(super).extend
      valueSets: valueSets

  sortAndFilterCriteria: (criteriaSet) ->
    _.chain(criteriaSet).sortBy((criteria) => criteria.valueSetName)
                        .sortBy((criteria) => criteria.name)
                        .uniq(true, (criteria) =>
                          criteria.name + criteria.valueSetName + criteria.oid)
                        .value()

  sortAndFilterCodes: (codes) ->
    _.chain(codes).sortBy((code) => code.display_name)
                  .sortBy((code) => code.code_system_name)
                  .uniq(true, (code) =>
                    code.code_system_name + code.display_name + code.code)
                  .value()
