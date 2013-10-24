class Thorax.Views.PatientBuilder extends Thorax.View

  template: JST['patient_builder']

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
    @serialize(children: false)
    for cid, childView of @editCriteriaCollectionView.children
      childView.serialize()
      # We need to through all the dates and change them back from user-readable to seconds
      @model.get('source_data_criteria').each (dc) ->
        dc.set 'start_date', moment(dc.get('start_date')).format('X') * 1000
        dc.set 'end_date', moment(dc.get('end_date')).format('X') * 1000
    @model.save()


class Thorax.Views.EditCriteriaView extends Thorax.View

  # FIXME: This use of setModel and context is hackish and roundabout;
  # Thorax auto-populates the form with the model data, which isn't
  # helpful when you want populate to use the context to set the form data

  setModel: ->
    super arguments..., populate: { context: true }

  context: ->
    start_date = moment(@model.get('start_date')).format('L') if @model.get('start_date')
    end_date = moment(@model.get('end_date')).format('L') if @model.get('end_date')
    _(super).extend start_date: start_date, end_date: end_date

  toggleDetails: (e) ->
    @$('.details').toggle()

  removeEncounter: (e) -> @model.destroy()

  newValue: (e) ->
    e.preventDefault()
    $(e.target).before(@templates.newValue())

  newFieldValue: (e) ->
    e.preventDefault()
    $(e.target).before(@templates.newFieldValue())
