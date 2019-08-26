#!/bin/bash

WORKING_DIR=/apps/stg/tacoma/ruby/bonnie/current
RAILS_ENV=production

cd $WORKING_DIR
bundle exec rake bonnie:db:dump RAILS_ENV=$RAILS_ENV
bundle exec rake bonnie:db:prune_dumps RAILS_ENV=$RAILS_ENV
