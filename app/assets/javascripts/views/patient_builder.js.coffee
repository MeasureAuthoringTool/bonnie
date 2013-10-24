class Thorax.Views.PatientBuilder extends Thorax.View

  template: JST['patient_builder']

  options:
    serialize: { children: false }
    populate: { children: false }

  initialize: ->
    @editCriteriaCollectionView = new Thorax.CollectionView
      collection: @model.get('source_data_criteria')
      itemView: Thorax.Views.EditCriteriaView
      itemTemplate: JST['patient_builder/edit_criteria']

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
    # Serialize the main view and the child collection views separately
    @serialize(children: false)
    childView.serialize() for cid, childView of @editCriteriaCollectionView.children
    @model.save()


class Thorax.Views.EditCriteriaView extends Thorax.View

  options:
    populate: { context: true }

  # When we create the form and populate it, we want to convert times to moment-formatted dates
  context: ->
    start_date = moment(@model.get('start_date')).format('L') if @model.get('start_date')
    end_date = moment(@model.get('end_date')).format('L') if @model.get('end_date')
    _(super).extend start_date: start_date, end_date: end_date

  # When we serialize the form, we want to convert formatted dates back to times
  events:
    serialize: (attr) ->
      attr.start_date = moment(attr.start_date).format('X') * 1000 if attr.start_date
      attr.end_date = moment(attr.end_date).format('X') * 1000 if attr.end_date

  toggleDetails: (e) ->
    @$('.details').toggle()

  removeEncounter: (e) -> @model.destroy()

  newValue: (e) ->
    e.preventDefault()
    $(e.target).before(@templates.newValue())

  newFieldValue: (e) ->
    e.preventDefault()
    $(e.target).before(@templates.newFieldValue())
