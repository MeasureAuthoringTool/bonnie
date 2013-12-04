# FIXME deprecated; remove soon.
class Thorax.Views.Patients extends Thorax.View
  template: JST['patients/patients']
  delStart: (e) ->
    # console.log $(e.target).model()
    @$('.delete-' + $(e.target).model().id).toggle()
  deletePatient: (e) ->
    patient = $(e.target).model()
    patient.destroy()
  clonePatient: (e) ->
    patient = $(e.target).model()
    bonnie.navigateToPatientBuilder patient.deepClone(omit_id: true)
