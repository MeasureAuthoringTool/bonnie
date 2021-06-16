print("Conversion started...");
// Update statistics
const updateStat = {
  deviceApplied: 0, //number of Device Applied deleted
  numberEnc: 0, //number of EncounterPerformed.negationRationale deleted
  numberParticipationRecorder: 0, //number of Participation.recorder deleted
  procPerformedPriority: 0, //number of ProcedurePerformed.priority deleted
  organizationUpdate: 0, //number of Organisation updated
  cardinalities: 0, //number of cardinalities changed
  numberOfMeasures: 0 //number of measures updated(remove Device, Applied element)
};

const qdm_version = '5.6';

// remove EncounterPerformed.negationRationale
function removeEncPerformedNegation(encPerformed) {
  if (encPerformed.hasOwnProperty('negationRationale')) {
    delete encPerformed.negationRationale;
    updateStat.numberEnc += 1;
  }
}

// remove Participation.recorder
function removeParticipationRecorder(participation) {
  if (participation.hasOwnProperty('recorder')) {
    delete participation.recorder;
    updateStat.numberParticipationRecorder += 1;
  }
}

// remove ProcedurePerformed.priority
function removeProcedurePerformedPriority(procedurePerformed) {
  if (procedurePerformed.hasOwnProperty('priority')) {
    delete procedurePerformed.priority;
    updateStat.procPerformedPriority += 1;
  }
}

// update cardinality of entities
// update organization type of entities(if entity type is organization)
function updateEntityCardinalities(dataElement) {
  const entities = ['participant', 'performer', 'sender', 'recipient',
    'dispenser', 'prescriber', 'requester', 'recorder'];

  entities.forEach((entity) => {
    // update entity cardinality from 0..1 to 0..*
    if(dataElement[entity]) {
      // update organization Type if entity is an organization
      if (dataElement[entity]._type === 'QDM::Organization') {
        dataElement[entity].organizationType = dataElement[entity].type;
        delete dataElement[entity].type;
        updateStat.organizationUpdate += 1;
      }
      // update qdm version of an entity
      dataElement[entity].qdmVersion = qdm_version;
      // cardinality change, make it an array
      dataElement[entity] = [dataElement[entity]];
      updateStat.cardinalities += 1;
    }
  });
}

db.getCollection('cqm_patients').find().forEach(function (patient) {
  print(`------------Updating patient : ${patient._id} ---------------` );
  const dataElements = patient.qdmPatient.dataElements;
  // empty patient, not possible but if in case
  if (!dataElements) {
    return;
  }
  patient.qdmPatient.dataElements = dataElements.filter(dataElement => {
    print(`Data element: ${dataElement._type}`);
    // update data element qdm version
    dataElement.qdmVersion = qdm_version;
    // no need to update patient characteristics
    if(dataElement.qdmCategory === 'patient_characteristic') {
      return true;
    }

    switch (dataElement._type) {
      case 'QDM::DeviceApplied':
        updateStat.deviceApplied += 1;
        return false;
      case 'QDM::EncounterPerformed':
        removeEncPerformedNegation(dataElement);
        break;
      case 'QDM::Participation':
        removeParticipationRecorder(dataElement);
        break;
      case 'QDM::ProcedurePerformed':
        removeProcedurePerformedPriority(dataElement);
        break;
      default:
        print('Do nothing');
    }
    updateEntityCardinalities(dataElement);
    return true;
  });

  // update qdm version of a patient
  patient.qdmPatient.qdmVersion = qdm_version;
  db.getCollection('cqm_patients').update(
    { _id: patient._id},
    patient,
    { multi: false }
  );
});

// update measures to remove QDM::DeviceApplied retired data element
print(`------------Updating measures---------------` );
db.getCollection('cqm_measures').find().forEach(function (measure) {
  const sourceDataCriteria = measure.source_data_criteria
  if (!sourceDataCriteria) {
    return;
  }
  measure.source_data_criteria = sourceDataCriteria.filter(
    (dataCriteria) => {
      if(dataCriteria._type === 'QDM::DeviceApplied') {
        print(`Removing DeviceApplied from measure: ${measure._id}`);
        return false;
      } else {
        return true;
      }
    }
  )
  if(measure.source_data_criteria.length !== sourceDataCriteria.length) {
    updateStat.numberOfMeasures += 1;
    db.getCollection('cqm_measures').update(
      { _id: measure._id},
      measure,
      { multi: false }
    );
  }
});

print(JSON.stringify(updateStat));
print("Conversion completed successfully");
