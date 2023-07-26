// this script removes OBSERV array from ratio measure patients
print("Observation data removal started...");
const patientsUpdated = {}
db.getCollection('cqm_patients').find().forEach((patient) => {
  print(`Checking if elligible : ${patient._id}` );
  const expectedValues = patient.expectedValues;
  if (!expectedValues) {
    print('Not elligible, no need to update' );
    return;
  }
  expectedValues.forEach((expectedValue) => {
    if (expectedValue.hasOwnProperty('OBSERV') && !expectedValue.hasOwnProperty('MSRPOPL')) {
      print(`Updating patient : ${patient._id}` );
      db.getCollection('cqm_patients').updateOne(
        { _id: patient._id},
        {
          $unset: {'expectedValues.$[].OBSERV': ""}
        }
      );
      patientsUpdated[`${patient._id}`] =`${patient.familyName} ${patient.givenNames[0]}`
    } else {
      print(`Does not have OBSERV or not a ratio patient: ${patient._id}`);
    }
  })
});
print(JSON.stringify(patientsUpdated));
print("Number of patients updated: ", Object.keys(patientsUpdated).length);
print("Observation data removal completed");