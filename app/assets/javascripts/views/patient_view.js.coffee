class Thorax.Views.Patient extends Thorax.View
  
  template: JST['patient']
  
  birthDate: -> new Date(this.birthdate)
  
  payerName: -> this.insurance_providers[0]['name']
  
  valid_measure_ids: -> 
    validIds = {}
    this.measure_ids.map (m) -> 
      if bonnie.measures.findWhere({id: m})
        validIds[m] = {key: m, value: 1}
      else
      	validIds[m] = {key: m, value: 0}
    return validIds