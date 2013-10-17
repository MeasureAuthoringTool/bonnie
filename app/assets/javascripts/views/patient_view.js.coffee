class Thorax.Views.Patient extends Thorax.View
  
  template: JST['patient']

  birthDate: -> @model.getBirthDate()
  payerName: -> @model.getPayerName()
  validMeasureIds: -> @model.getValidMeasureIds(@measures)