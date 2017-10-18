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
print("## DELETING USERS AND ASSOCIATED DATA IF NO SIGN ON SINCE 1/1/17")
users = db.getCollection('users').find({last_sign_in_at: {$lte: new ISODate("2017-01-01 00:00:00.000Z")}});
user_ids = db.getCollection('users').distinct("_id", {last_sign_in_at: {$lte: new ISODate("2017-01-01 00:00:00.000Z")}},{_id: 1});
delete_users_information(users, user_ids);

// remove all users who have never logged in and their associated data
print("## DELETING USERS AND ASSOCIATED DATA IF NO SIGN ONS")
users = db.getCollection('users').find({sign_in_count:0});
user_ids = db.getCollection('users').distinct("_id", {sign_in_count:0},{_id: 1});
delete_users_information(users, user_ids);

print("## DELETING ORPHANED PATIENTS");
delete_orphans(db.getCollection('records'));
print("## DELETING ORPHANED MEASURES");
delete_orphans(db.getCollection('cql_measures'));
print("## DELETING ORPHANED VALUE SETS");
delete_orphans(db.getCollection('health_data_standards_svs_value_sets'));

print("## DELETING FIELDS 'too_big', 'has_measure_history', 'calc_results', 'description', 'description_category' FROM RECORDS");
db.getCollection('records').update( {}, {$unset: {too_big:"", has_measure_history:"", calc_results:"", description:"", description_category:""}}, {multi:true});

print("## CHANGE RECORD FIELD 'is_shared' TO FALSE");
db.getCollection('records').update( {}, {$set: {is_shared:false}}, {multi:true});

db.getCollection('records').find({"user_id": {$in: db.getCollection('users').distinct("_id", {"last_sign_in_at": {$lte: new ISODate("2017-01-01 00:00:00.000Z")}},{_id: 1})}})


// delete the users and all data associated with the users
function delete_users_information(users, user_ids) {
  print("* DELETING PATIENTS")
  db.getCollection('records').remove({"user_id": {$in: user_ids}})
  print("* DELETING MEASURES")
  db.getCollection('cql_measures').remove({"user_id": {$in: user_ids}})
  print("* DELETING VALUESETS")
  db.getCollection('health_data_standards_svs_value_sets').remove({"user_id": {$in: user_ids}})
  
  users.forEach( function(user) {
    // print("## DELETING DATA RELATED TO USER: `" + user.email + "` with id " + user._id.toString());
    // 
    // measures = db.getCollection('cql_measures').find({"user_id":user._id});
    // patients = db.getCollection('records').find({"user_id":user._id});
    // value_sets = db.getCollection('health_data_standards_svs_value_sets').find({"user_id":user._id});
    
    if(user.bundle_id) {
      print("* DELETE BUNDLE: " + user.bundle_id.toString());
      db.getCollection('bundles').remove({_id: user.bundle_id});
    }
    
    // measures.forEach( function (measure) {
    //   print("* DELETE MEASURE: \t`" + measure.title + '` `' + measure.cms_id + "` \twith id " + measure._id.toString());
    //   db.getCollection('cql_measures').remove({_id: measure._id});
    // });
    // patients.forEach( function (patient) {
    //   print("* DELETE PATIENT: \t`" + patient.first + ' ' + patient.last + "` \twith id " + patient._id.toString());
    //   db.getCollection('records').remove({_id: patient._id});
    // });
    // value_sets.forEach( function (value_set) {
    //   print("* DELETE VALUESET: \t`" + value_set.display_name + '` `' + value_set.oid + "` \twith id " + value_set._id.toString());
    //   db.getCollection('health_data_standards_svs_value_sets').remove({_id: value_set._id});
    // });
    print("* DELETE USER: \t\t`" + user.email + "` \twith id " + user._id.toString());
    db.getCollection('users').remove({_id: user._id});
  });
};

// delete all items in the collection that do not have an associated existing user
function delete_orphans(collection) {
  cursor = collection.find({});
  cursor.forEach( function(doc) {
    user = db.getCollection('users').findOne({_id: doc.user_id});
    if(!user) {
      print("DELETE " + doc._id.toString()); 
      collection.remove({_id: doc._id});
    }
  });
}
