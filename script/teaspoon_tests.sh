#!/bin/sh

# Script to run all teaspoon tests by directory

# Save the lcov.info files and report all at the end to avoid teaspoon errors on
# travis.
echo 'Running spec/javascripts/cqm_specs tests ...'
bundle exec rake teaspoon DIR='cqm_specs'
echo 'Running spec/javascripts/fhir_measures tests ...'
bundle exec rake teaspoon DIR='fhir_measures'
echo 'Running spec/javascripts/helper_specs tests ...'
bundle exec rake teaspoon DIR='helper_specs'
echo 'Running spec/javascripts/integration tests ...'
bundle exec rake teaspoon DIR='integration'
echo 'Running spec/javascripts/models tests ...'
bundle exec rake teaspoon DIR='models'
echo 'Running spec/javascripts/patient_builder_tests/cql tests ...'
bundle exec rake teaspoon DIR='patient_builder_tests/cql'
echo 'Running spec/javascripts/patient_builder_tests/input_views tests ...'
bundle exec rake teaspoon DIR='patient_builder_tests/input_views'
echo 'Running spec/javascripts/patient_builder_tests/measure tests ...'
bundle exec rake teaspoon DIR='patient_builder_tests/measure'
echo 'Running spec/javascripts/patient_builder_tests/patient tests ...'
bundle exec rake teaspoon DIR='patient_builder_tests/patient'
echo 'Running spec/javascripts/production_tests tests ...'
bundle exec rake teaspoon DIR='production_tests'
echo 'Running spec/javascripts/calc tests ...'
bundle exec rake teaspoon DIR='calc'


