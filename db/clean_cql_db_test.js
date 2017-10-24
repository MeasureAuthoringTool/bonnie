print("# Checking counts for all users");
get_counts({});
print("# Checking counts for users that have accessed Bonnie after 1/1/2017");
get_counts({last_sign_in_at: {$gt: new ISODate("2017-01-01 00:00:00.000Z")}});
print("# Checking counts for users that have not accessed Bonnie after 1/1/2017");
get_counts({last_sign_in_at: {$lte: new ISODate("2017-01-01 00:00:00.000Z")}});
print("# Checking counts for users that have never accessed Bonnie");
get_counts({sign_in_count:0});

print("# Orphans");
get_orphan_counts({});

print("# Extraneous field counts (note: some of these always are 'nil')");
records_with_field_set("too_big");
records_with_field_set("has_measure_history");
records_with_field_set("calc_results");

print("# Patients with 'is_shared' as true")
count = db.getCollection('records').find({is_shared:true}).count()
print("\tPatients count: " + count.toString());

print("# List of collection names");
db.getCollectionNames().forEach( function(colName) {print("\t" + colName);});

function get_counts(query) {
  user_ids = db.getCollection('users').distinct("_id", query, {_id: 1});
  bundle_ids = db.getCollection('users').distinct("bundle_id", query, {bundle_id: 1});

  count = db.getCollection('records').find({"user_id": {$in: user_ids}}).count();
  print("\tPatient count: " + count.toString());

  count = db.getCollection('cql_measures').find({"user_id": {$in: user_ids}}).count();
  print("\tMeasure count: " + count.toString());

  count = db.getCollection('health_data_standards_svs_value_sets').find({"user_id": {$in: user_ids}}).count();
  print("\tValue set count: " + count.toString());

  count = db.getCollection('bundles').find({"_id": {$in: bundle_ids}}).count();
  print("\tBundle count: " + count.toString());

  count = db.getCollection('users').find({"_id": {$in: user_ids}}).count();
  print("\tUser count: " + count.toString());
}

function get_orphan_counts(query) {
  user_ids = db.getCollection('users').distinct("_id", query, {_id: 1});
  bundle_ids = db.getCollection('users').distinct("bundle_id", query, {bundle_id: 1});

  count = db.getCollection('records').find({"user_id": {$nin: user_ids}}).count();
  print("\tPatient count: " + count.toString());

  count = db.getCollection('cql_measures').find({"user_id": {$nin: user_ids}}).count();
  print("\tMeasure count: " + count.toString());

  count = db.getCollection('health_data_standards_svs_value_sets').find({"user_id": {$nin: user_ids}}).count();
  print("\tValue set count: " + count.toString());

  count = db.getCollection('bundles').find({"_id": {$nin: bundle_ids}}).count();
  print("\tBundle count: " + count.toString());
}

function records_with_field_set(field) {
  field_hash = {}
  field_hash[field] = {$exists : true}
  count = db.getCollection('records').find(field_hash).count()
  print("\tPatients with field " + field + " count: " + count.toString());
}
