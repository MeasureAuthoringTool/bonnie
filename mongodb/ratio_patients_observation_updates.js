print("Observation data removal started...");
const patientsUpdated = {}
db.getCollection('cqm_patients').find().forEach((patient) => {
  print(`-------Updating patient : ${patient._id} ------------` );
  const expectedValues = patient.expectedValues;
  // empty patient, not possible but if in case
  if (!expectedValues) {
    return;
  }
  expectedValues.forEach((expectedValue) => {
    if (expectedValue.hasOwnProperty('OBSERV') && !expectedValue.hasOwnProperty('MSRPOPL')) {
      delete expectedValue.OBSERV
      patientsUpdated[`${patient._id}`] =`${patient.familyName} ${patient.givenNames[0]}`
    }
  })
  // update patient
  if (patientsUpdated[`${patient._id}`]) {
    db.getCollection('cqm_patients').update(
      { _id: patient._id},
      patient,
      { multi: false }
    );
  }
});
print(JSON.stringify(patientsUpdated));
print("Number of patients updated: ", Object.keys(patientsUpdated).length);
print("Observation data removal completed");