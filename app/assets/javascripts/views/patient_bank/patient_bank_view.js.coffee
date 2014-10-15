class Thorax.Views.PatientBankView extends Thorax.Views.BonnieView
  template: JST['patient_bank/patient_bank']

  initialize: ->
    @collection = new Thorax.Collections.Patients
