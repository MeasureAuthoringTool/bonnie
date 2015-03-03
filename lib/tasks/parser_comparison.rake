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

    desc 'Given a zip file with SimpleXML and HQMF, create HTML that shows logic for each'
    task :create_html => :environment do

      raise "Need to specify zip file using FILE" unless ENV['FILE']

      Zip::ZipFile.open(ENV['FILE']) do |zip_file|

        hqmf = zip_file.glob(File.join('**','**eMeasure.xml')).first
        simple_xml = zip_file.glob(File.join('**','**SimpleXML.xml')).first
        value_sets = zip_file.glob(File.join('**','**.xls')).first

        Dir.mktmpdir("measure_files", Rails.root.join('tmp')) do |tmpdir|

          hqmf_path = File.join(tmpdir, Pathname.new(hqmf.name).basename)
          zip_file.extract(hqmf, hqmf_path)
          simple_xml_path = File.join(tmpdir, Pathname.new(simple_xml.name).basename)
          zip_file.extract(simple_xml, simple_xml_path)
          value_sets_path = File.join(tmpdir, Pathname.new(value_sets.name).basename)
          zip_file.extract(value_sets, value_sets_path)

          hqmf_model = Measures::Loader.parse_hqmf_model(hqmf_path)
          simple_xml_model = Measures::Loader.parse_hqmf_model(simple_xml_path)
          value_set_models = Measures::ValueSetLoader.load_value_sets_from_xls(value_sets_path)

          hqmf_model.backfill_patient_characteristics_with_codes(HQMF2JS::Generator::CodesToJson.from_value_sets(value_set_models))
          hqmf_model = hqmf_model.to_json
          hqmf_model.convert_keys_to_strings
          hqmf_model = Measures::Loader.load_hqmf_model_json(hqmf_model, nil, value_set_models.map(&:oid))

          hqmf_html = measure_logic_html(hqmf_model, value_set_models)
          hqmf_html_file = "#{hqmf_model.cms_id}_HQMFR2.html"
          File.write(hqmf_html_file, hqmf_html)
          puts "Wrote HQMFR2.1 HTML to #{hqmf_html_file}"

          simple_xml_model.backfill_patient_characteristics_with_codes(HQMF2JS::Generator::CodesToJson.from_value_sets(value_set_models))
          simple_xml_model = simple_xml_model.to_json
          simple_xml_model.convert_keys_to_strings
          simple_xml_model = Measures::Loader.load_hqmf_model_json(simple_xml_model, nil, value_set_models.map(&:oid))

          simple_xml_html = measure_logic_html(simple_xml_model, value_set_models)
          simple_xml_html_file = "#{simple_xml_model.cms_id}_SimpleXML.html"
          File.write(simple_xml_html_file, simple_xml_html)
          puts "Wrote SimpleXML HTML to #{simple_xml_html_file}"

          raise 'Bad file names' unless (hqmf_html_file + simple_xml_html_file).match(/\A[a-zA-Z0-9._-]+\Z/)
          system("open #{hqmf_html_file} #{simple_xml_html_file}")

        end
      end

    end

  end
end
