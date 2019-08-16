# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require_relative '../lib/tasks/fixture_helper'

user = User.create(email: 'bonnie@example.com', password: 'b0nn13p455', approved: true, admin: true)
user.save!

if ENV['DEMO'] == 'true'
  puts 'Setting up measure and patients for demo database.'
  load_measure_fixtures_from_folder(File.join('measures', 'CMS123v7'), user)
  patients_set = File.join('cqm_patients', 'CMS123v7')
  collection_fixtures(patients_set)
  associate_user_with_patients(User.first, CQM::Patient.all)
  associate_user_with_patients(User.first, CQM::Patient.all)
  associate_user_with_measures(User.first, CQM::Measure.all)
end
