class Thorax.Views.VariablesLogic extends Thorax.Views.BonnieView
  template: JST['logic/variables']
  events:
    'click .panel-population' : -> @$('.toggle-icon').toggleClass('fa-angle-right fa-angle-down')

  initialize: ->
    @variables = new Thorax.Collections.MeasureDataCriteria this.measure.get('source_data_criteria').select (dc) -> dc.get('variable') && !dc.get('specific_occurrence')
    @hasVariables = @variables.length > 0

  # Need to add this so that variables will have a type when it comes to handling the mouseover hightlighting
  population:
    type: "VAR"
