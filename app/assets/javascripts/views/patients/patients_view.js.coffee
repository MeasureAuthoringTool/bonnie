class Thorax.Views.Patients extends Thorax.View
  template: JST['patients/patients']
  deletePatient: (e) ->
    @model = $(e.target).model()
    @model.destroy()