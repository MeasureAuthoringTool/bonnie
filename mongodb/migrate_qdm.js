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
        private: true,
        name: "personal group for " + user.email,
    });
    print("Adding user to the default group : " + user.email);
    db.users.update(
        { _id: user._id },
        { $set: { groups_ids: [user._id], current_group_id: user._id } }
    );
});
// # Rename cqm_measure_packages.user_id -> cqm_measure_packages.group_id
db.cqm_measure_packages.find().forEach(function (pkg) {
    print(
        "Updating package : " +
        pkg._id
    );
    db.cqm_measure_packages.update(
        { _id: pkg._id },
        { $rename: { user_id: "group_id" } }
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
// # Rename each cqm_value_sets.user_id field → cqm_value_sets.group_id
db.cqm_value_sets.find().forEach(function (vs) {
    print(
        "Updating value_set : " +
        vs._id +
        " " +
        vs.display_name
    );
    db.cqm_value_sets.update(
        { _id: vs._id },
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

print("dropping cqm_measure_packages indices");
db.cqm_measure_packages.getIndexes().forEach(function (idx) {
    let idxKeys = Object.keys(Object.assign({}, idx.key));
    if (idxKeys.includes("user_id")) {
        print("Index " + idx.name + " should be removed");
        db.getCollection("cqm_measure_packages").dropIndex(idx.name);
    }
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
print("dropping cqm_value_sets indices");
db.cqm_value_sets.getIndexes().forEach(function (idx) {
    let idxKeys = Object.keys(Object.assign({}, idx.key));
    if (idxKeys.includes("user_id")) {
        print("Index " + idx.name + " should be removed");
        db.getCollection("cqm_value_sets").dropIndex(idx.name);
    }
});

// Indexing can take time
print("creating indexes for users");
db.users.createIndex({ group_ids: 1 });

print("creating indexes for cqm_measure_packages");
db.cqm_measure_packages.createIndex({ group_ids: 1 });

print("creating indexes for cqm_measures");
db.cqm_measures.createIndex({ group_id: 1 });
db.cqm_measures.createIndex({ group_id: 1, set_id: 1 });

print("creating indexes for cqm_patients");
db.cqm_patients.createIndex({ group_id: 1 });
db.cqm_patients.createIndex({ group_id: 1, measures_id: 1 });

print("creating indexes for cqm_value_sets");
db.cqm_value_sets.createIndex({ group_ids: 1 });


print("Migration completed");