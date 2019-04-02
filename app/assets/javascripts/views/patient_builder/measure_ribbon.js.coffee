class Thorax.Views.MeasureRibbon extends Thorax.CollectionView
  className: 'measure-ribbon'
  initialize: ->
    @collection = new Thorax.Collections.Population bonnie.measures.chain().map((m) -> m.get('populations').models).flatten().value()
    @itemView = (item) => new Thorax.Views.MeasureRibbonCell
      patient: @model
      population: item.model

class Thorax.Views.MeasureRibbonCell extends Thorax.Views.BuilderChildView
  tagName: 'span'
  className: 'ribbon-cell'
  template: JST['patient_builder/measure_ribbon']
  context: ->
    cms_id: @population.collection.parent.get('cqmMeasure').cms_id
    sub_id: @population.get('sub_id')
  initialize: ->
    @model = @population.differenceFromExpected(@patient)
    @patient.on 'materialize', =>
      @population.differenceFromExpected(@patient).once 'change:done', (diff, done) =>
        @model.set diff.attributes if done
  events:
    rendered: ->
      if !@model.get('done') or _(@model.get('comparisons')).all((c) -> !c.expected and !c.actual)
        @$el.hide()
      else
        @$el.show()
        d3.select(@$el.find('.ribbon-viz').get(0)).datum(@model.get('comparisons')).call(bonnie.viz.MeasureRibbonCell())
  activate: ->
    @$el.addClass('active').siblings('.active').removeClass('active')
    @trigger 'bonnie:loadPopulation', @population
