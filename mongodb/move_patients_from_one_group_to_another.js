/*
Command to execute this script:
To transfer test patients for measure CMS177 with hqmf id "ABC-2PQ-QQ5" from account/group named "John Doe",
to measure CMS177 with hqmf id "WBC-3PQ-B0NI3" in account/group named "Jane Doe"

mongo localhost:27017/bonnie_db --eval 'let sourceGroupName="John Doe", targetGroupName="Jane Doe", sourceHqmfId="ABC-2PQ-QQ5", targetHqmfId="WBC-3PQ-B0NI3"' <PATH>/mongodb/move_patients_from_one_group_to_another.js

*/


print("Patient transfer started....");
print("-----------Command line arguments to script-------------");
print("Source group name: ", sourceGroupName);
print("Target group name: ", targetGroupName);
print("Source measure HQMF id: ", sourceHqmfId);
print("Target measure HQMF id: ", targetHqmfId);
print("--------------------------------------------------------");

// Get the source group id
let sourceGroup = db.getCollection('groups').find({name:sourceGroupName});
if (sourceGroup.count() === 0) {
  print("Source group not found...existing the script");
  quit(1);
}
print("Source group id: ", sourceGroup[0]._id);

// Get the target group id
const targetGroup = db.getCollection('groups').find({name:targetGroupName});
if (targetGroup.count() === 0) {
  print("Target group not found...existing the script");
  quit(1);
}
print("Target group id: ", targetGroup[0]._id);

// move patients from source group, to target group
db.getCollection('cqm_patients').update(
  {
    $and: [
      { measure_ids: { $in:[sourceHqmfId] } },
      { group_id: sourceGroup[0]._id }
    ]
  },
  {
    $set: {
      measure_ids: [targetHqmfId],
      group_id: targetGroup[0]._id
    }
  },
  { multi: true }
);


print("Patient transfer completed successfully!");