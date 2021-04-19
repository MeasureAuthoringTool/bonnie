#!/bin/bash
# parameters
source_schema=bonnie_development
target_schema=$source_schema
dump_dir=/tmp
connection=localhost:27017
# dump source / restore to target
mongodump --db=$source_schema --out=$dump_dir
# run migration scripts
mongo $connection/$target_schema migrate_qdm.js