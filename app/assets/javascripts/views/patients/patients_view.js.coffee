# FIXME deprecated; remove soon.
class Thorax.Views.Patients extends Thorax.View
  template: JST['patients/patients']
  deletePatient: (e) ->
    patient = $(e.target).model()
    patient.destroy()
  clonePatient: (e) ->
    patient = $(e.target).model()
    bonnie.navigateToPatientBuilder patient.deepClone()
