class Thorax.Views.PatientBuilder extends Thorax.View

  template: JST['patient_builder']

  initialize: ->
    @criteriaViewClass = Thorax.Views.CriteriaView

  dataCriteriaCategories: ->
    categories = {}
    @measure.get('source_data_criteria').each (criteria) ->
      categories[criteria.get('type')] ||= new Thorax.Collection
      categories[criteria.get('type')].add criteria unless categories[criteria.get('type')].any (c) -> c.get('title') == criteria.get('title')
    categories
  
  events:
    'submit form': 'save'
    rendered: ->
      @$('.draggable').draggable revert: 'invalid', helper: 'clone'
      @$('.droppable').droppable accept: '.ui-draggable'
      # TODO move event handling up into events object, if possible
      @$('.droppable').on 'drop', _.bind(@drop, this)

  drop: (e, ui) ->
    measureDataCriteria = $(ui.draggable).model()
    @model.get('source_data_criteria').add measureDataCriteria.toPatientDataCriteria()

  save: (e) ->
    e.preventDefault()
    @serialize e, (attributes, release) ->
      console.log attributes
      release()


class Thorax.Views.CriteriaView extends Thorax.View

  # FIXME: This use of setModel and context is hackish and roundabout;
  # Thorax auto-populates the form with the model data, which isn't
  # helpful when you want populate to use the context to set the form data

  setModel: ->
    super arguments..., populate: { context: true }

  context: ->
    _(super).extend
      start_date: moment(@model.get('start_date')).format('L')
      end_date: moment(@model.get('end_date')).format('L')

  toggleDetails: (e) ->
    @$('.details').toggle()

  removeEncounter: (e) -> @model.destroy()

  newValue: (e) ->
    e.preventDefault()
    $(e.target).before(@templates.newValue())

  newFieldValue: (e) ->
    e.preventDefault()
    $(e.target).before(@templates.newFieldValue())

