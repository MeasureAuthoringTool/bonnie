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
        
        patient = Record.first
        measure = Measure.first
        
        start_time = Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 1, 1)
        end_time = Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 12, 31)
        
        qrda_exporter = HealthDataStandards::Export::Cat1.new 'r3_1'
        ret_file= qrda_exporter.export(patient, [measure], start_time, end_time, nil, 'r3_1')
        ret_xml = Nokogiri::XML(ret_file)
        
        expected_file = Dir.glob(File.join("test", "fixtures", "qrda", test_dir, "*.xml"))[0]
        expected_xml = Nokogiri::XML(File.read(expected_file))
        errors = []
        EquivalentXml.equivalent?(expected_xml, ret_xml, {:element_order => false, 
          :normalize_whitespace => true, 
          :ignore_content => ["ClinicalDocument realmCode",
            "ClinicalDocument effectiveTime"]}) {|n1, n2, result| puts "#{n1.name} #{result}"; errors.push([n1, n2]) unless result}
            
        
        errors.each do |err|
        end
      end
      assert_equal [], total_errors, "QRDA Export Errors Found: #{total_errors.size}"
    end
      
  end
  
end