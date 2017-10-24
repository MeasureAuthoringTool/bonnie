// To run: in terminal:
// Open mongo from the commandline
// Switch to the bonnie database
// type load(<absolute path to script>/convert_hqmf_version_number_to_string.js)
// e.g.
// $mongo
// > use bonnie_alpha
// > load("/Users/edeyoung/Documents/projects/bonnie/git/bonnie/db/clean_cql_db.js")

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
query_hash = {last_sign_in_at: {$lte: new ISODate("2017-01-01 00:00:00.000Z")}}
delete_users_information(query_hash);

// remove all users who have never logged in and their associated data
print("## DELETING USERS AND ASSOCIATED DATA IF NO SIGN ONS")
query_hash = {sign_in_count:0}
delete_users_information(query_hash);

// user ids of all remaining users
user_ids = db.getCollection('users').distinct("_id", {}, {_id: 1});
bundle_ids = db.getCollection('users').distinct("bundle_id", {}, {bundle_id: 1});

// remove orphans
print("## DELETING ORPHANED PATIENTS");
removed_result = db.getCollection('records').remove({"user_id": {$nin: user_ids}})
print("\t" + removed_result.nRemoved.toString() + " removed");

print("## DELETING ORPHANED MEASURES");
removed_result = db.getCollection('cql_measures').remove({"user_id": {$nin: user_ids}})
print("\t" + removed_result.nRemoved.toString() + " removed");

print("## DELETING ORPHANED VALUE SETS");
removed_result = db.getCollection('health_data_standards_svs_value_sets').remove({"user_id": {$nin: user_ids}})
print("\t" + removed_result.nRemoved.toString() + " removed");

print("## DELETING ORPHANED BUNDLES");
removed_result = db.getCollection('bundles').remove({"_id": {$nin: bundle_ids}})
print("\t" + removed_result.nRemoved.toString() + " removed");

print("## DELETING FIELDS 'too_big', 'has_measure_history', 'calc_results' FROM RECORDS");
db.getCollection('records').update( {}, {$unset: {too_big:"", has_measure_history:"", calc_results:""}}, {multi:true});

print("## CHANGE RECORD FIELD 'is_shared' TO FALSE");
db.getCollection('records').update( {}, {$set: {is_shared:false}}, {multi:true});



// delete the users and all data associated with the users
function delete_users_information(query) {
  users = db.getCollection('users').find(query);
  user_ids = db.getCollection('users').distinct("_id", query, {_id: 1});
  bundle_ids = db.getCollection('users').distinct("bundle_id", query, {bundle_id: 1});

  print("* DELETING PATIENTS")
  removed_result = db.getCollection('records').remove({"user_id": {$in: user_ids}})
  print("\t" + removed_result.nRemoved.toString() + " removed");
  
  print("* DELETING MEASURES")
  removed_result = db.getCollection('cql_measures').remove({"user_id": {$in: user_ids}})
  print("\t" + removed_result.nRemoved.toString() + " removed");
  
  print("* DELETING VALUESETS")
  removed_result = db.getCollection('health_data_standards_svs_value_sets').remove({"user_id": {$in: user_ids}})
  print("\t" + removed_result.nRemoved.toString() + " removed");
  
  print("* DELETING BUNDLES")
  removed_result = db.getCollection('bundles').remove({"_id": {$in: bundle_ids}})
  print("\t" + removed_result.nRemoved.toString() + " removed");
  
  print("* DELETING USERS")
  removed_result = db.getCollection('users').remove({"_id": {$in: user_ids}})
  print("\t" + removed_result.nRemoved.toString() + " removed");
};
