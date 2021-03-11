# parameters
source_schema=bonnie_fhir_development
target_schema=$source_schema
dump_dir=/Users/serhii.ilin/Downloads/databases
connection=localhost:27017
# dump source / restore to target
mongodump --db=$source_schema --out=$dump_dir
# run migration scripts
mongo $connection/$target_schema migrate.js
