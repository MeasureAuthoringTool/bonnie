#!/bin/sh

# Script to run all teaspoon tests by directory

# Save the lcov.info files and report all at the end to avoid teaspoon errors on
# travis.
bundle exec rake teaspoon DIR='cqm_specs'
mv ./coverage-frontend/default/lcov.info ./coverage-frontend/default/lcov.info.cqm_specs
bundle exec rake teaspoon DIR='helper_specs'
mv ./coverage-frontend/default/lcov.info ./coverage-frontend/default/lcov.info.helper_specs
bundle exec rake teaspoon DIR='integration'
mv ./coverage-frontend/default/lcov.info ./coverage-frontend/default/lcov.info.integration
bundle exec rake teaspoon DIR='models'
mv ./coverage-frontend/default/lcov.info ./coverage-frontend/default/lcov.info.models
bundle exec rake teaspoon DIR='patient_builder_tests'
mv ./coverage-frontend/default/lcov.info ./coverage-frontend/default/lcov.info.patient_builder_tests
bundle exec rake teaspoon DIR='production_tests'
mv ./coverage-frontend/default/lcov.info ./coverage-frontend/default/lcov.info.production_tests
bundle exec rake teaspoon DIR='views'
mv ./coverage-frontend/default/lcov.info ./coverage-frontend/default/lcov.info.views
bundle exec rake teaspoon DIR='javascripts'
mv ./coverage-frontend/default/lcov.info ./coverage-frontend/default/lcov.info.javascripts

# Send all the reports to github
# codecov script is expecting the report to be in lcov.info
mv ./coverage-frontend/default/lcov.info.cqm_specs ./coverage-frontend/default/lcov.info
bash <(curl -s https://codecov.io/bash) -cF cqm_specs
mv ./coverage-frontend/default/lcov.info.helper_specs ./coverage-frontend/default/lcov.info
bash <(curl -s https://codecov.io/bash) -cF helper_specs
mv ./coverage-frontend/default/lcov.info.integration ./coverage-frontend/default/lcov.info
bash <(curl -s https://codecov.io/bash) -cF integration
mv ./coverage-frontend/default/lcov.info.models ./coverage-frontend/default/lcov.info
bash <(curl -s https://codecov.io/bash) -cF models
mv ./coverage-frontend/default/lcov.info.patient_builder_tests ./coverage-frontend/default/lcov.info
bash <(curl -s https://codecov.io/bash) -cF patient_builder_tests
mv ./coverage-frontend/default/lcov.info.production_tests ./coverage-frontend/default/lcov.info
bash <(curl -s https://codecov.io/bash) -cF production_tests
mv ./coverage-frontend/default/lcov.info.views ./coverage-frontend/default/lcov.info
bash <(curl -s https://codecov.io/bash) -cF views
mv ./coverage-frontend/default/lcov.info.javascripts ./coverage-frontend/default/lcov.info
bash <(curl -s https://codecov.io/bash) -cF javascripts
