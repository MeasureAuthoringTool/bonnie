require 'test_helper'

class PatientBuilderTest < ActiveSupport::TestCase

  setup do
    collection_fixtures("draft_measures", "users")
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    @measure_ids = ["E35791DF-5B25-41BB-B260-673337BC44A8"] # hqmf_set_id
    @data_criteria = HQMF::DataCriteria.get_settings_for_definition('diagnosis','active')
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
                                                                            HealthDataStandards::SVS::Concept.new({"code_system_name" => "SNOMED", "code" =>"SNO2"})]})
                  } # todo need to fake some of these out

    @coded_source_data_critria = {
          "id"=> "DiagnosisActiveLimitedLifeExpectancy",
          "start_date"=> 1333206000000,
          "end_date"=> 1333206000000,
          "value"=>[{"type"=>"CD","code_list_id"=>"2.16.840.1.113883.3.464.1003.102.12.1011","title"=>"Acute Pharyngitis", "codes" =>[{"LOINC"=>["LOINC_2"]}]}],
          "negation"=>"true",
          "negation_code_list_id"=>"2.16.840.1.113883.3.464.1003.106.12.1005",
          "negation_code" => {"code_system" => "SNOMED", "code" =>"222222"},
          "field_values"=>{"ORDINAL"=>{"type"=>"CD","code_list_id"=>"2.16.840.1.113883.3.526.3.1139","title"=>"ACE inhibitor or ARB", "code" =>{"code_system"=>"CPT", "code"=>"CHACHA2", "title"=>nil}}},
          "code_list_id"=> "2.16.840.1.113883.3.526.3.1492",
          "codes"=> [{"CPT" =>["CPT1"]}]
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
