# PatientSource is a necessary structure for the CQL (ELM) Execution Engine.
# Uses CQL_QDM Patient API to map Bonnie patients to correct format for the Execution Engine.
class PatientSource
  constructor: (@patients) -> @index = 0
  currentPatient: -> new CQL_QDM.CQLPatient(@patients[@index]) if @index < @patients.length
  nextPatient: -> @index += 1
