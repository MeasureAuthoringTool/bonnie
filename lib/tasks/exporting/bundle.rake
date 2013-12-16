require File.expand_path('../../../../config/environment',  __FILE__)
require 'bonnie_bundler'
BonnieBundler.logger = Log4r::Logger.new("Bonnie Bundler")
BonnieBundler.logger.outputters = Log4r::Outputter.stdout
def export(measures,rebuild,calculate,source_directory)
  measure_config = APP_CONFIG.merge! YAML.load_file(Rails.root.join('config','measures', 'measures_2_4_0.yml'))["measures"]
  config = APP_CONFIG.merge(measure_config)
  config["source_directory"] = source_directory
  config["base_dir"] ||= "tmp/bundle-#{config["version"]}"
  config["name"] ||= "bundle-#{config["version"]}-#{Time.now.to_i}"
  config["valueset_sources"] ="db"
  exporter = Measures::Exporter::BundleExporter.new(measures,config)
  exporter.rebuild_measures if rebuild=="true" || config["rebuild_measures"]
  exporter.calculate if calculate=="true"|| config["calculate"]

  exporter.export
  exporter.compress_artifacts
end


namespace :bonnie do
  namespace :export do

    desc "bundle all measures"
    task :bundle_all ,[:rebuild,:calculate,:source_directory] do |t, args|
      export(Measure.all,args.rebuild,args.calculate,args.source_directory)
    end

    desc "bundle all measures for a user"
    task :bundle_user ,[:user,:rebuild,:calculate,:source_directory] do |t, args|
     export(Measure.where({:user=>args.user}),args.rebuild,args.calculate,args.source_directory)
    end

    desc "bundle a specific measure"
    task :bundle_measure ,[:measure,:rebuild,:calculate,:source_directory] do |t, args|
      export(Measure.where({hqmf_id: args.measure}),args.rebuild,args.calculate,args.source_directory)
    end

    task :bundle ,[:filter,:rebuild,:calculate,:source_directory] do |t, args|
      export(Measure.where(JSON.parse(args.filter)),args.rebuild,args.calculate,args.source_directory)
    end

  end
end
