require 'test_helper'

class PatientBuilderTest < ActiveSupport::TestCase

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(measures_set, users_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    @measure_ids = ["E35791DF-5B25-41BB-B260-673337BC44A8"] # hqmf_set_id
    @data_criteria = HQMF::DataCriteria.get_settings_for_definition('diagnosis','active')
    @data_criteria_encounter = HQMF::DataCriteria.get_settings_for_definition('encounter','performed')
    @data_criteria_labtest = HQMF::DataCriteria.get_settings_for_definition('laboratory_test', 'performed')
    @valuesets = {"2.16.840.1.113883.3.526.3.1492"=>HealthDataStandards::SVS::ValueSet.new({"oid" => "2.16.840.1.113883.3.526.3.1492", "concepts"=>[
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"99201"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"99202"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "CPT", "code" =>"CPT1"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "CPT", "code" =>"CPT2"})]}),
                  
                  "2.16.840.1.113883.3.464.1003.102.12.1011"=>HealthDataStandards::SVS::ValueSet.new({"oid" => "2.16.840.1.113883.3.464.1003.102.12.1011" , "concepts"=>[
                                                                                      HealthDataStandards::SVS::Concept.new({"code_system_name" => "LOINC", "code" =>"LOINC_1"}),
                                                                                      HealthDataStandards::SVS::Concept.new({"code_system_name" => "LOINC", "code" =>"LOINC_2"}),
                                                                                      HealthDataStandards::SVS::Concept.new({"code_system_name" => "AOCS", "code" =>"A_1"}),
                                                                                      HealthDataStandards::SVS::Concept.new({"code_system_name" => "AOCS", "code" =>"A_2"})]}),
                  
                  "2.16.840.1.113883.3.464.1003.106.12.1005"=>HealthDataStandards::SVS::ValueSet.new({"oid" => "2.16.840.1.113883.3.464.1003.106.12.1005", "concepts"=>[
                                                                                     HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"999999"}),
                                                                                     HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"222222"})]}),
                  
                  "2.16.840.1.113883.3.526.3.1139"=>HealthDataStandards::SVS::ValueSet.new({"oid" => "2.16.840.1.113883.3.526.3.1139" , "concepts"=>[
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "CPT", "code" =>"CHACHA1"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "CPT", "code" =>"CHACHA2"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"SNO1"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"SNO2"})]}),
                   "2.16.840.1.113883.3.526.3.1259"=>HealthDataStandards::SVS::ValueSet.new({"oid" => "2.16.840.1.113883.3.526.3.1259" , "concepts"=>[
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "CPT", "code" =>"CHACHA1"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "CPT", "code" =>"CHACHA2"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"SNO1"}),
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"SNO2"})]}),
                   "2.16.840.1.113883.3.666.5.1084"=>HealthDataStandards::SVS::ValueSet.new({"oid" => "2.16.840.1.113883.3.666.5.1084" , "concepts"=>[
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "CPT", "code" =>"CHACHA1"})]})
                  } # todo need to fake some of these out

    @coded_source_data_critria = {
          "id"=> "DiagnosisActiveLimitedLifeExpectancy",
          "start_date"=> 1333206000000,
          "end_date"=> 1333206000000,
          "value"=>[{"type"=>"CD","code_list_id"=>"2.16.840.1.113883.3.464.1003.102.12.1011","title"=>"Acute Pharyngitis", "codes" =>{"LOINC"=>["LOINC_2"]}}],
          "negation"=>"true",
          "negation_code_list_id"=>"2.16.840.1.113883.3.464.1003.106.12.1005",
          "negation_code" => {"code_system" => "SNOMED", "code" =>"222222"},
          "field_values"=>{"ORDINAL"=>{"type"=>"CD","code_list_id"=>"2.16.840.1.113883.3.526.3.1139","title"=>"ACE inhibitor or ARB", "code" =>{"code_system"=>"CPT", "code"=>"CHACHA2", "title"=>nil}}},
          "code_list_id"=> "2.16.840.1.113883.3.526.3.1492",
          "codes"=> {"CPT" =>["CPT1"]},
          "code_source"=>Measures::PatientBuilder::CODE_SOURCE[:USER_DEFINED]
        }

    @source_data_criteria_with_id = {
      "negation" => "false",
      "definition" => "medication",
      "status" => "dispensed",
      "title" => "AntidepressantMedication",
      "description" => "Medication, Dispensed=> Antidepressant Medication",
      "code_list_id" => "2.16.840.1.113883.3.464.1003.196.12.1213",
      "type" => "medications",
      "id" => "AntidepressantMedication_MedicationDispensed_40280381_3d61_56a7_013e_7af6125a640d_source",
      "start_date" => 1346054400000,
      "end_date" => 1346055300000,
      "value" => [],
      "references" => "null",
      "field_values" => {
          "DISPENSER_IDENTIFIER" => {
              "type" => "ID",
              "code_list_id" => "",
              "field_title" => "Dispenser Identifier",
              "root" => "testId",
              "extension" => "testSystem"
          }
       }
      }

    @un_coded_source_data_critria = {
          "id"=> "DiagnosisActiveLimitedLifeExpectancy",
          "start_date"=> 1333206000000,
          "end_date"=> 1333206000000,
          "value"=>[{"type"=>"CD","code_list_id"=>"2.16.840.1.113883.3.464.1003.102.12.1011","title"=>"Acute Pharyngitis"}],
          "negation"=>"true",
          "negation_code_list_id"=>"2.16.840.1.113883.3.464.1003.106.12.1005",
          "field_values"=>{"ORDINAL"=>{"type"=>"CD","code_list_id"=>"2.16.840.1.113883.3.526.3.1139","title"=>"ACE inhibitor or ARB"}},
          "code_list_id"=> "2.16.840.1.113883.3.526.3.1492"
          }    

    @un_coded_with_facility = {
      "id"=> "EncounterPerformedInpatient",
      "start_date"=> 1333206000000,
      "end_date"=> 1333206000000,
      "negation"=>"false",
      "field_values"=>{
        "FACILITY_LOCATION"=>
          {"type"=>"COL",
            "values"=>
              [{"type"=>"FAC", "key"=>"FACILITY_LOCATION", "code_list_id"=>"2.16.840.1.113883.3.666.5.1084", "field_title"=>"Facility Location", "locationPeriodLow"=>"08/30/2017 1:00 AM", "locationPeriodHigh"=>"08/31/2017 1:00 AM", "title"=>"Annual Wellness Visit"},
                {"type"=>"FAC", "key"=>"FACILITY_LOCATION", "code_list_id"=>"2.16.840.1.113883.3.666.5.1084", "field_title"=>"Facility Location", "locationPeriodLow"=>"08/30/2017 2:00 AM", "locationPeriodHigh"=>"08/31/2017 3:00 AM", "title"=>"Annual Wellness Visit"}],
              "field_title"=>"Facility Location"}
        },
        "code_list_id"=> "2.16.840.1.113883.3.526.3.1492"
      }
          
    @un_coded_with_component = {
      "negation" => "false",
      "id" => "LDL_c_LaboratoryTestPerformed",
      "start_date" => 1332316800000,
      "end_date" => 1332317700000,
      "field_values" => {
        "COMPONENT"=>
          {"type"=>"COL",
           "values"=>
            [{"type"=>"CMP", "key"=>"COMPONENT", "code_list_id"=>"2.16.840.1.113883.3.464.1003.102.12.1011", "field_title"=>"Component", "value"=>"5", "unit"=>"mg", "title"=>"Hemorrhagic Stroke"},
             {"type"=>"CMP", "key"=>"COMPONENT", "code_list_id"=>"2.16.840.1.113883.3.464.1003.102.12.1011", "field_title"=>"Component", "value"=>"33", "unit"=>"cc", "title"=>"Hemorrhagic Stroke"}],
           "field_title"=>"Component"}
        },
        "code_list_id"=> "2.16.840.1.113883.3.526.3.1492"
      }     
              
    @source_with_range_value = {
          "id"=> "DiagnosisActiveLimitedLifeExpectancy",
          "start_date"=> 1333206000000,
          "end_date"=> 1333206000000,
          "value"=>[{"type"=>"PQ","value"=>"1","unit"=>"xx"}],
          "negation"=>"false",
          "code_list_id"=> "2.16.840.1.113883.3.526.3.1492"
        }

    @communication_source_data_criteria = {
          "negation"=>true, 
          "definition"=>"communication",
          "status"=>"performed",
          "title"=>"Written Information Given", 
          "description"=>"Communication, Performed: Written Information Given",
          "code_list_id"=>"2.16.840.1.113883.3.117.1.7.1.415", 
          "type"=>"communications", 
          "id"=>"CommunicationPerformedWrittenInformationGiven",
          "start_date"=>1348560000000, 
          "end_date"=>1348560900000, 
          "value"=>[], 
          "references"=>{}, 
          "field_values"=>{},
          "hqmf_set_id"=>"217FDF0D-3D64-4720-9116-D5E5AFA27F2C", 
          "cms_id"=>"CMS107v3", 
          "criteria_id"=>"15004fd3075Fm", 
          "codes"=>{}, 
          "negation_code_list_id"=>"2.16.840.1.113883.3.117.1.7.1.93", 
          "coded_entry_id"=>"5609535d0ab013862e000007", 
          "code_source"=>"DEFAULT"
        }

  end
  
  test "derive entry" do
    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@un_coded_source_data_critria, @valuesets)
    assert entry, "Should have created an entry with un coded data"
    assert_equal Condition, entry.class, "should have created and Encounter object"
    
    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@coded_source_data_critria, @valuesets)
    assert entry, "Should have created an entry with  coded data"
    assert_equal Condition, entry.class, "should have created and Encounter object"
    assert_equal @coded_source_data_critria["codes"], entry.codes
  end

  test "derive entry with ID type field value" do
    med_data_criteria = HQMF::DataCriteria.get_settings_for_definition('medication','dispensed')
    entry = Measures::PatientBuilder.derive_entry(med_data_criteria,@source_data_criteria_with_id, @valuesets)
    Measures::PatientBuilder.derive_field_values(entry,@source_data_criteria_with_id["field_values"],@valuesets)

    assert entry, "Should have created an entry with ID field value"
    assert_equal Medication, entry.class, "should have created a Medication object"
    assert_equal entry.dispenserIdentifier, {"value"=>"testId", "namingSystem"=>"testSystem"}
  end

  test "derive communication" do
    @data_criteria_communication = HQMF::DataCriteria.get_settings_for_definition('communication_performed','')
    entry = Measures::PatientBuilder.derive_entry(@data_criteria_communication,@communication_source_data_criteria,@valuesets)
    
    assert entry, "Should have created an entry with communication data_criteria"
    assert_equal Communication, entry.class, "should have created a Communication object"
  end

  test "derive negation" do
    
    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@un_coded_source_data_critria, @valuesets)
    assert  !entry.negation_ind, "negation should be false"
    assert entry.negation_reason.nil?, "Negation should have no codes"

    Measures::PatientBuilder.derive_negation(entry,@un_coded_source_data_critria,@valuesets)
    assert entry.negation_ind, "negation should be true"
    code ={"code_system" => "SNOMED" , "code" =>"999999"}
    assert_equal code, entry.negation_reason, "Negation codes should have been auto selected"

    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@coded_source_data_critria, @valuesets)
    
    Measures::PatientBuilder.derive_negation(entry,@coded_source_data_critria,@valuesets)
    assert entry.negation_ind, "negation should be true"
    assert_equal @coded_source_data_critria["negation_code"], entry.negation_reason, "Negation codes shoudl equal provided codes"
  end

  test "derive entry with facility" do
    entry = Measures::PatientBuilder.derive_entry(@data_criteria_encounter,@un_coded_with_facility, @valuesets)
    assert entry, "Should have created an entry with un coded data"
    assert_equal Encounter, entry.class, "should have created and Encounter object"
    Measures::PatientBuilder.derive_field_values(entry, @un_coded_with_facility['field_values'],@valuesets)
    assert !entry.facility.nil?, "facility collection should have been created"
    assert_equal 2, entry.facility['values'].length
    # A facility has a Facility Location code, locationPeriodLow, locationPeriodHigh
    facility = entry.facility['values'][1]
    facility_location = entry.facility['values'][1]['code']
    locationPeriodLow = facility['locationPeriodLow']
    locationPeriodHigh = facility['locationPeriodHigh']
    # A facility location has a code and code system
    facility_location_code = facility_location['code']
    facility_location_code_system = facility_location['code_system']
    assert !facility_location.nil?, "facility should have a facility_location"
    assert !locationPeriodLow.nil?, "facility should have a locationPeriodLow"
    assert !locationPeriodHigh.nil?, "facility should have a locationPeriodHigh"
    assert !facility_location_code.nil?, "facility_location should have a code"
    assert !facility_location_code_system.nil?, "facility_location should have a code_system"
  end
  
  test "derive entry with components" do
    entry = Measures::PatientBuilder.derive_entry(@data_criteria_labtest, @un_coded_with_component, @valuesets)
    assert entry, "Should have created an entry with un coded data"
    # LaboratoryTestPerformed is a VitalSign because its patient_api_function defined in HDS/data_criteria.json
    # maps to the patient_api_extention hQuery.Patient::laboratoryTests = -> this.results().concat(this.vitalSigns())
    assert_equal VitalSign, entry.class, "should have created and Laboratory object"
    Measures::PatientBuilder.derive_field_values(entry, @un_coded_with_component['field_values'], @valuesets)
    assert !entry.components.nil?, "components collection should have been created"
    assert_equal 2, entry.components['values'].length
    # A component has a code and a result
    code = entry.components['values'][1]['code']
    result = entry.components['values'][1]['result']
    assert_equal "LOINC", code['code_system']
    assert_equal "LOINC_1", code['code']
    assert_equal "33", result['scalar']
    assert_equal "cc", result['units']
  end

  test "derive time range"  do 
    time_criteria = { "start_date" => 1333206000000, "end_date" => 1333206000000 }
    range = Measures::PatientBuilder.derive_time_range(time_criteria)
    assert range.low.nil? == false
    assert range.high.nil? == false

    time_criteria = { "start_date" => nil, "end_date" => 1333206000000 }
    range = Measures::PatientBuilder.derive_time_range(time_criteria)
    assert range.low.nil?
    assert range.high.nil? == false


    time_criteria = { "start_date" => 1333206000000, "end_date" => nil }
    range = Measures::PatientBuilder.derive_time_range(time_criteria)
    assert range.low.nil? == false
    assert range.high.nil? 

    time_criteria = { "start_date" => nil, "end_date" => nil }
    range = Measures::PatientBuilder.derive_time_range(time_criteria)
    assert range.low.nil?
    assert range.high.nil?

  end

  test "derive values" do

    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@un_coded_source_data_critria,@valuesets)
    
    assert entry.values.nil? || entry.values.empty? , "There should be no values"

    Measures::PatientBuilder.derive_values(entry,@un_coded_source_data_critria["value"],@valuesets)
    expected_length = @un_coded_source_data_critria["value"].length
    assert_equal expected_length, entry.values.length, "Should have created #{expected_length} values"
    assert_equal({"LOINC"=>["LOINC_1"], "AOCS"=>["A_1"]}, entry.values[0].codes ) 

    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@coded_source_data_critria, @valuesets)
    assert entry.values.nil? || entry.values.empty? , "There should be no values"
    Measures::PatientBuilder.derive_values(entry,@coded_source_data_critria["value"],@valuesets)
    expected_length = @un_coded_source_data_critria["value"].length
    assert_equal expected_length, entry.values.length, "Should have created #{expected_length} values"
    assert_equal @coded_source_data_critria["value"][0]["codes"], entry.values[0].codes 

    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@source_with_range_value, @valuesets)
    assert entry.values.nil? || entry.values.empty? , "There should be no values"
    Measures::PatientBuilder.derive_values(entry,@source_with_range_value["value"],@valuesets)
    expected_length = @source_with_range_value["value"].length
    assert_equal expected_length, entry.values.length, "Should have created #{expected_length} values"
    assert_equal @source_with_range_value["value"][0]["value"], entry.values[0].scalar 
    assert_equal @source_with_range_value["value"][0]["unit"], entry.values[0].units
  end

  test "derive field"  do 
    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@un_coded_source_data_critria, @valuesets)
    assert entry.values.nil? || entry.values.empty? , "There should be no values"
    Measures::PatientBuilder.derive_field_values(entry,@un_coded_source_data_critria["field_values"],@valuesets)

    assert !entry.ordinality.nil?, "Should have created an ordinal filed value"
    
    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@coded_source_data_critria, @valuesets)
    assert entry.values.nil? || entry.values.empty? , "There should be no values"
    Measures::PatientBuilder.derive_field_values(entry,@coded_source_data_critria["field_values"],@valuesets)
    assert_equal({"code_system"=>"CPT", "code"=>"CHACHA2", "title"=>nil}, entry.ordinality, "Should have created an ordinal filed value")
  end

  test "get value sets" do
    vs_oids = Measures::PatientBuilder.get_vs_oids(@coded_source_data_critria)
    assert vs_oids.include?('2.16.840.1.113883.3.464.1003.102.12.1011')
    assert vs_oids.include?('2.16.840.1.113883.3.464.1003.106.12.1005')
    assert vs_oids.include?('2.16.840.1.113883.3.464.1003.102.12.1011')
    assert vs_oids.include?('2.16.840.1.113883.3.526.3.1139')
    assert vs_oids.include?('2.16.840.1.113883.3.526.3.1492')
  end

end 
