require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  
  
  setup do
  end
  
  test "QRDA Export Test" do
    
    fixtures_base = File.join("test", "fixtures", "qrda")
    total_errors = []
    Dir.foreach(fixtures_base) do |test_dir|
      if (!test_dir.eql?(".") && !test_dir.eql?(".."))
        puts "\nQRDA TEST: #{test_dir}\n"

        dump_database
        measure_dir = File.join("draft_measures", "qrda", test_dir)
        value_sets_dir = File.join("health_data_standards_svs_value_sets", "qrda", test_dir)
        patient_dir = File.join("records", "qrda", test_dir)
        user_dir = File.join("users", "qrda", test_dir)
        collection_fixtures(user_dir, value_sets_dir, measure_dir, patient_dir)

        user = User.first
        patient = Record.first
        measure = Measure.first

        associate_user_with_measures(user, [measure])
        associate_user_with_patients(user, [patient])
        associate_measure_with_patients(measure, [patient])

        HealthDataStandards::SVS::ValueSet.all.each do |vs|
          vs.bundle_id = BSON::ObjectId.from_string(user.bundle_id)
          vs.save
        end

        start_time = Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 1, 1)
        end_time = Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 12, 31)
        
        qrda_exporter = HealthDataStandards::Export::Cat1.new 'r3_1'
        ret_file= qrda_exporter.export(patient, [measure], start_time, end_time, nil, 'r3_1')
        ret_xml = Nokogiri::XML(ret_file)
        
        expected_file = Dir.glob(File.join("test", "fixtures", "qrda", test_dir, "*.xml"))[0]
        expected_xml = Nokogiri::XML(File.read(expected_file))

        tags_to_remove = ["ClinicalDocument id", "ClinicalDocument effectiveTime", "ClinicalDocument time"]
        tags_to_remove.each do |code|
          gen_code = ret_xml.search(code).remove
          ex_code = expected_xml.search(code).remove
        end

        errors = []
        EquivalentXml.equivalent?(expected_xml, ret_xml, {:element_order => false, 
          :normalize_whitespace => true}) {|n1, n2, result| errors.push([n1.name, n1.values, n2.name, n2.values]) unless result;}
            
        
        errors.each do |err|
          puts "#{err[0]} #{err[1]} #{err[2]} #{err[3]}"
          total_errors.push(err)
        end
      end
      assert_equal [], total_errors, "QRDA Export Errors Found: #{total_errors.size}"
    end
      
  end
  
end