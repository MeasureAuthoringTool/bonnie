require 'simplecov'
require 'codecov'

SimpleCov.start do
  add_filter "test/"
  add_filter "lib/tasks/bonnie_run_once.rake"
  add_filter "lib/tasks/vsac.rake"
  add_filter "lib/tasks/cql_testing.rake"
  add_filter "lib/util/fixture_exporter.rb"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
  add_group "Models", "app/models"
  add_group "Measures", "lib/measures"
  add_group "Patient Builder", "lib/generation"
  add_group "Extensions", "lib/ext"
end

SimpleCov.formatter = SimpleCov::Formatter::Codecov
SimpleCov.minimum_coverage(87.3)
