require 'simplecov'
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

class SimpleCov::Formatter::QualityFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    File.open("coverage/covered_percent", "w") do |f|
      f.puts result.source_files.covered_percent.to_f
    end
  end
end

SimpleCov.formatter = SimpleCov::Formatter::QualityFormatter
SimpleCov.minimum_coverage(87.3)
