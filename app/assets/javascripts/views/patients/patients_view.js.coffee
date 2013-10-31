class Thorax.Views.Patients extends Thorax.View
  template: JST['patients/patients']
  events:
    'submit form': 'deletePatient'
  deletePatient: (e) ->
    e.preventDefault()
    @serialize()
    @model = $(e.target).model()
    @model.destroy({data: {authenticity_token: $('meta[name="csrf-token"]')[0].content}, processData: true})