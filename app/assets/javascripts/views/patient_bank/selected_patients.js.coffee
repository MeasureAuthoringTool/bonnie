class Thorax.Views.SelectedPatients extends Thorax.Views.BonnieView
  template: JST['patient_bank/selected_patients']
  tagName: "span"
  className: "patient-select-count"

  events:
    'click .clear-selected': 'clearSelection'

  clearSelection: ->
    @collection.reset()
