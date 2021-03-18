print("Migration started");
// Create a new group collection
db.createCollection("groups");
// Create a record in the group collection for each user. Those will be used as user private groups
// group.id can be equal to user.id (for migration simplicity)
// Update each user object with user.groups = [private group id]
// Update each user object with user.current_group = private group id
db.users.find().forEach(function (user) {
  print("Creating default/personal group for : " + user.email);
  db.groups.insert({
    _id: user._id,
    is_personal: true,
    name: "personal group for " + user.email,
  });
  print("Adding user to the default group : " + user.email);
  db.users.update(
    { _id: user._id },
    { $set: { groups_ids: [user._id], current_group_id: user._id } }
  );
});
// # Rename each measure.user_id field → measure.group_id
db.cqm_measures.find().forEach(function (measure) {
  print(
    "Updating measure : " +
      measure._id +
      " " +
      measure.set_id +
      " " +
      measure.title
  );
  db.cqm_measures.update(
    { _id: measure._id },
    { $rename: { user_id: "group_id" } }
  );
});
// # Rename each patient.user_id field → patient.group_id
db.cqm_patients.find().forEach(function (patient) {
  print("Updating patient : " + patient._id);
  db.cqm_patients.update(
    { _id: patient._id },
    { $rename: { user_id: "group_id" } }
  );
});
print("dropping cqm_measures indices");
db.cqm_measures.getIndexes().forEach(function (idx) {
  let idxKeys = Object.keys(Object.assign({}, idx.key));
  if (idxKeys.includes("user_id")) {
    print("Index " + idx.name + " should be removed");
    db.getCollection("cqm_measures").dropIndex(idx.name);
  }
});
print("dropping cqm_patients indices");
db.cqm_patients.getIndexes().forEach(function (idx) {
  let idxKeys = Object.keys(Object.assign({}, idx.key));
  if (idxKeys.includes("user_id")) {
    print("Index " + idx.name + " should be removed");
    db.getCollection("cqm_patients").dropIndex(idx.name);
  }
});
// Indexing can take time
print("creating indexes for users");
db.users.createIndex({ group_ids: 1 });

print("creating indexes for cqm_measures");
db.cqm_measures.createIndex({ group_id: 1 });
db.cqm_measures.createIndex({ group_id: 1, set_id: 1 });
//
print("creating indexes for cqm_patients");
db.cqm_patients.createIndex({ group_id: 1 });
db.cqm_patients.createIndex({ group_id: 1, measures_id: 1 });

print("Migration completed");
