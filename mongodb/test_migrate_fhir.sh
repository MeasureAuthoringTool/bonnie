# parameters
source_schema=bonnie_fhir_development
target_schema=bonnie_fhir_development2
dump_dir=/tmp
connection=localhost:27017
# drop target if exists
mongo $target_schema --eval "printjson(db.dropDatabase())"
# dump source / restore to target
mongodump --db=$source_schema --out=$dump_dir
mongorestore -d $target_schema $dump_dir/$source_schema
# run migration scripts
mongo $connection/$target_schema migrate_fhir.js
