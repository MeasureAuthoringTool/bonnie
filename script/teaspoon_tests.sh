#!/bin/sh

# Script to run all teaspoon tests by directory

bundle exec rake teaspoon DIR='cqm_specs'
bundle exec rake teaspoon DIR='helper_specs'
bundle exec rake teaspoon DIR='integration'
bundle exec rake teaspoon DIR='models'
bundle exec rake teaspoon DIR='patient_builder_tests'
bundle exec rake teaspoon DIR='production_tests'
bundle exec rake teaspoon DIR='views'
bundle exec rake teaspoon DIR='javascripts'