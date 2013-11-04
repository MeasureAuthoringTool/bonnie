class Thorax.Views.DataCriteriaLogic extends Thorax.View
  
  template: JST['logic/data_criteria']
  operator_map: 
    'XPRODUCT':'AND'
    'UNION':'OR'

  initialize: ->
    @dataCriteria = @dataCriteriaMap[@reference]
    # we need to do this because the view helper doesn't seem to be available in an #each.
    if @dataCriteria.field_values
      for key, field of @dataCriteria.field_values
        field['key'] = key
        field['key_title'] = @translate_field(key)

  translate_operator: (conjunction) =>
    @operator_map[conjunction]

  translate_field: (field_key) =>
    Thorax.Models.Measure.logicFields[field_key]?['title']
