# -*- coding: utf-8 -*-
namespace :bonnie do
  namespace :parser_comparison do

    def measure_logic_html(measure, value_sets=nil)
      app_css = Rails.application.assets.find_asset('application.css').source
      app_javascript = Rails.application.assets.find_asset('application.js').source
      # D3 gets cute and uses π, λ, etc, which don't embed into HTML
      app_javascript.gsub!('π', 'piForD3')
      app_javascript.gsub!('λ', 'lambdaForD3')
      app_javascript.gsub!('τ', 'tauForD3')
      app_javascript.gsub!('ρ', 'rhoForD3')
      app_javascript.gsub!('φ', 'phiForD3')
      app_javascript.gsub!('δ', 'deltaForD3')
      app_javascript.gsub!('γ', 'gammaForD3')
      app_javascript.gsub!('Δ', 'bigDeltaForD3')
      value_sets ||= measure.value_sets
      value_sets_by_oid = value_sets.index_by(&:oid)
      html_template = ERB.new File.read(Rails.root.join('lib', 'templates', 'measure_logic.html.erb'))
      html_template.result binding
    end

    class MeasureZipExtractor
      attr_reader :value_set_models
      def initialize(zip_file_name)
        @zip_file = Zip::ZipFile.open(zip_file_name)
        @tmpdir = Dir.mktmpdir("measure_files", Rails.root.join('tmp'))
        value_sets = @zip_file.glob(File.join('**','**.xls')).first
        value_sets_path = File.join(@tmpdir, Pathname.new(value_sets.name).basename)
        @zip_file.extract(value_sets, value_sets_path)
        @value_set_models = Measures::ValueSetLoader.load_value_sets_from_xls(value_sets_path)
      end
      def extract(type)
        case type
        when :simple_xml
          file_matcher = '**SimpleXML.xml'
        when :hqmf
          file_matcher = '**eMeasure.xml'
        end
        zip_data = @zip_file.glob(File.join('**', file_matcher)).first
        path = File.join(@tmpdir, Pathname.new(zip_data.name).basename)
        @zip_file.extract(zip_data, path)
        model = Measures::Loader.parse_hqmf_model(path)
        model.backfill_patient_characteristics_with_codes(HQMF2JS::Generator::CodesToJson.from_value_sets(@value_set_models))
        model = model.to_json
        model.convert_keys_to_strings
        Measures::Loader.load_hqmf_model_json(model, nil, @value_set_models.map(&:oid))
      end
      def close
        @zip_file.close
        FileUtils.remove_entry_secure @tmpdir
      end
    end

    desc 'Given a zip file with SimpleXML and HQMF, create HTML that shows logic for each'
    task :create_html => :environment do

      raise "Need to specify zip file using FILE" unless ENV['FILE']

      zip_extractor = MeasureZipExtractor.new(ENV['FILE'])

      hqmf_model = zip_extractor.extract :hqmf
      hqmf_html = measure_logic_html(hqmf_model, zip_extractor.value_set_models)
      hqmf_html_file = "#{hqmf_model.cms_id}_HQMFR2.html"
      File.write(hqmf_html_file, hqmf_html)
      puts "Wrote HQMFR2.1 HTML to #{hqmf_html_file}"

      simple_xml_model = zip_extractor.extract :simple_xml
      simple_xml_html = measure_logic_html(simple_xml_model, zip_extractor.value_set_models)
      simple_xml_html_file = "#{simple_xml_model.cms_id}_SimpleXML.html"
      File.write(simple_xml_html_file, simple_xml_html)
      puts "Wrote SimpleXML HTML to #{simple_xml_html_file}"

      raise 'Bad file names' unless (hqmf_html_file + simple_xml_html_file).match(/\A[a-zA-Z0-9._-]+\Z/)
      system("open #{hqmf_html_file} #{simple_xml_html_file}")

      zip_extractor.close

    end

  end
end
