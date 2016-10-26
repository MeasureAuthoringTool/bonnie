class PatientSource
  constructor: (@patients) -> @index = 0
  currentPatient: -> new CQL_QDM.CQLPatient(@patients[@index]) if @index < @patients.length
  nextPatient: -> @index += 1
