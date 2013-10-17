class Thorax.Views.PatientBuilder extends Thorax.View
  template: JST['patient_builder/form']
  events:
    rendered: ->
      @$('.draggable').draggable revert: 'invalid', helper: 'clone'
      @$('.droppable').droppable accept: '.ui-draggable'
      # TODO move event handling up into events object
      @$('.droppable').on 'drop', _.bind(@drop, this)

  drop: (e, ui) ->
    dataCriteria = $(ui.draggable).model()
    encounters = @model.get 'source_data_criteria'
    encounters.add dataCriteria