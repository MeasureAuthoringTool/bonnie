// To run: in terminal:
// Open mongo from the commandline
// Switch to the bonnie database
// type load(<absolute path to script>/convert_hqmf_version_number_to_string.js)
// e.g.
// $mongo
// > use bonnie_alpha
// > load("/Users/edeyoung/Documents/projects/bonnie/git/bonnie/db/convert_hqmf_version_number_to_string.js")

// entirely remove collections that are no longer used
db.draft_measures.drop();
db.archived_measures.drop();
db.history_trackers.drop();
db.measures.drop();
db.patient_cache.drop();
db.providers.drop();
db.upload_summaries.drop();

// remove all users that have not signed in since before 1/1/17 and their associated data
users = db.getCollection('users').find({"last_sign_in_at": {$lte: new ISODate("2017-01-01 00:00:00.000Z")}});
delete_users_information(users);

// remove all users who have never logged in and their associated data
users = db.getCollection('users').find({sign_in_count:0});
delete_users_information(users);

print("## DELETING ORPHANED PATIENTS")
delete_orphans(db.getCollection('records'));
print("## DELETING ORPHANED MEASURES")
delete_orphans(db.getCollection('cql_measures'));
print("## DELETING ORPHANED VALUE SETS")
delete_orphans(db.getCollection('health_data_standards_svs_value_sets'));

// delete the users and all data associated with the users
function delete_users_information(users) {
  users.forEach( function(user) {
    print("## DELETING DATA RELATED TO USER: `" + user.email + "` with id " + user._id.toString());
    
    measures = db.getCollection('cql_measures').find({"user_id":user._id});
    patients = db.getCollection('records').find({"user_id":user._id});
    value_sets = db.getCollection('health_data_standards_svs_value_sets').find({"user_id":user._id});
    
    
    // get bundle (which for some reason isn't linked to a user...)
    // should be the same bundle for the entire user account
    while (patients.hasNext()) {
      patient = patients.next();
      if (patient.bundle_id) {
        bundle = db.getCollection('bundles').findOne({_id: patient.bundle_id});
        print("* DELETE BUNDLE: \t`" + bundle.title + "` \twith id " + bundle._id.toString());
        db.getCollection('bundles').remove({_id: bundle._id});
        break;
      }
    }
    
    measures.forEach( function (measure) {
      print("* DELETE MEASURE: \t`" + measure.title + '` `' + measure.cms_id + "` \twith id " + measure._id.toString());
      db.getCollection('cql_measures').remove({_id: measure._id});
    });
    patients.forEach( function (patient) {
      print("* DELETE PATIENT: \t`" + patient.first + ' ' + patient.last + "` \twith id " + patient._id.toString());
      db.getCollection('records').remove({_id: patient._id});
    });
    value_sets.forEach( function (value_set) {
      print("* DELETE VALUESET: \t`" + value_set.display_name + '` `' + value_set.oid + "` \twith id " + value_set._id.toString());
      db.getCollection('health_data_standards_svs_value_sets').remove({_id: value_set._id});
    });
    print("* DELETE USER: \t\t`" + user.email + "` \twith id " + user._id.toString());
    db.getCollection('users').remove({_id: user._id});
  });
};

function delete_orphans(collection) {
  cursor = collection.find({});
  cursor.forEach( function(doc) {
    user = db.getCollection('users').findOne({_id: doc.user_id})
    if(!user) {
      print("DELETE " + doc._id.toString()); 
      collection.remove({_id: doc._id});
    }
  });
}
