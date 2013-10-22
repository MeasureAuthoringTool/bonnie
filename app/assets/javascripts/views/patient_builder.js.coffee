class Thorax.Views.EncounterInspector extends Thorax.View
  templates:
    popover: JST['patient_builder/inspector']
    newValue: JST['patient_builder/new_value']
    newFieldValue: JST['patient_builder/new_field_value']
  events:
    'click .popover-content .all-details.close': -> @$('.inspect-encounter').popover 'hide'
    'click .popover-content .value.close': (e) -> $(e.target).closest('.form-group').remove()
    rendered: ->
      @$('.inspect-encounter').popover
        content: @templates.popover(@model)

  newValue: (e) ->
    e.preventDefault()
    $(e.target).before(@templates.newValue())

  newFieldValue: (e) ->
    e.preventDefault()
    $(e.target).before(@templates.newFieldValue())

  removeEncounter: (e) -> @model.destroy()





class Thorax.Views.PatientBuilder extends Thorax.View
  template: JST['patient_builder/form']
  encounterInspectionView: Thorax.Views.EncounterInspector
  dataCriteriaCategories: ->
    categories = {}
    @measure.get('source_data_criteria').each (criteria) ->
      categories[criteria.get('type')] ||= new Thorax.Collection
      categories[criteria.get('type')].add criteria unless categories[criteria.get('type')].any (c) -> c.get('title') == criteria.get('title')
    categories
  
  events:
    rendered: ->
      @$('.draggable').draggable revert: 'invalid', helper: 'clone'
      @$('.droppable').droppable accept: '.ui-draggable'
      # TODO move event handling up into events object, if possible
      @$('.droppable').on 'drop', _.bind(@drop, this)

  drop: (e, ui) ->
    measureDataCriteria = $(ui.draggable).model()
    @model.get('source_data_criteria').add measureDataCriteria.toPatientDataCriteria()