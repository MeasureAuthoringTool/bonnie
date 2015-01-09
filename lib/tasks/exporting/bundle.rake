require File.expand_path('../../../../config/environment',  __FILE__)
require 'bonnie_bundler'
BonnieBundler.logger = Log4r::Logger.new("Bonnie Bundler")
BonnieBundler.logger.outputters = Log4r::Outputter.stdout

def export(user, rebuild, calculate, source_directory, measures_yml)
  measure_config = APP_CONFIG.merge! YAML.load_file(Rails.root.join('config','measures', measures_yml))["measures"]
  config = APP_CONFIG.merge(measure_config)
  config["source_directory"] = source_directory
  config["base_dir"] ||= "tmp/bundle-#{config["version"]}"
  config["name"] ||= "bundle-#{config["version"]}-#{Time.now.to_i}"
  config["valueset_sources"] ="db"
  config['use_cms'] = true
  exporter = Measures::Exporter::BundleExporter.new(user, config)
  exporter.rebuild_measures if rebuild=="true" || config["rebuild_measures"]
  exporter.calculate if calculate=="true"|| config["calculate"]

  exporter.export
  exporter.compress_artifacts
end


namespace :bonnie do
  namespace :export do

    desc "bundle all measures for a user (identified by email address)"
    task :bundle_user, [:user, :rebuild, :calculate, :source_directory, :measures_yml] do |t, args|
      user = User.where(email: args.user).first
      measures_yml = args.measures_yml || 'measures_2_5_0.yml'
      export(user, args.rebuild, args.calculate, args.source_directory, measures_yml)
    end

  end
end
