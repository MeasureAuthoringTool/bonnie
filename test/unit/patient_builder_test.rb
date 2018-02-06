require 'test_helper'

class PatientBuilderTest < ActiveSupport::TestCase

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("cql_measures", "CMS134v6")
    hds_svs_value_sets = File.join("health_data_standards_svs_value_sets", "CMS134v6")
    add_value_sets_collection(hds_svs_value_sets)
    records_set = File.join("records", "CMS134v6")
    collection_fixtures(users_set, records_set, measures_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, Measure.all)
    associate_user_with_patients(@user, Record.all)
    @data_criteria = HQMF::DataCriteria.get_settings_for_definition('diagnosis','active')
    @data_criteria_encounter = HQMF::DataCriteria.get_settings_for_definition('encounter','performed')
    @data_criteria_labtest = HQMF::DataCriteria.get_settings_for_definition('laboratory_test', 'performed')

    @p1 = Record.find_by(last:'Numer', first:'Pass')
    vs_oids = @p1.source_data_criteria.collect{|dc| Measures::PatientBuilder.get_vs_oids(dc)}.flatten.uniq
    @p1_valuesets =  Hash[*HealthDataStandards::SVS::ValueSet.in({oid: vs_oids, user_id: @p1.user_id}).collect{|vs| [vs.oid,vs]}.flatten]
    @p1_diagnosis_diabetes_sdc = @p1.source_data_criteria.find{|dc| dc['description'] == 'Diagnosis: Diabetes' }
    @p1_wellness_visit_sdc = @p1.source_data_criteria.find{|dc| dc['description'] == 'Encounter, Performed: Annual Wellness Visit' }
    @p1_lab_test_kidney_sdc = @p1.source_data_criteria.find{|dc| dc['description'] == 'Laboratory Test, Performed: Urine Protein Tests' && dc['start_date'] == 1343634300000}
    @p1_lab_test_1xx_sdc = @p1.source_data_criteria.find{|dc| dc['description'] == 'Laboratory Test, Performed: Urine Protein Tests' && dc['start_date'] == 1343635200000}

    @p2 = Record.find_by(last:'Denex', first:'Fail_Hospice_Not_Performed')
    vs_oids = @p2.source_data_criteria.collect{|dc| Measures::PatientBuilder.get_vs_oids(dc)}.flatten.uniq
    @p2_valuesets =  Hash[*HealthDataStandards::SVS::ValueSet.in({oid: vs_oids, user_id: @p2.user_id}).collect{|vs| [vs.oid,vs]}.flatten]
    @p2_intervention_order_sdc = @p2.source_data_criteria.find{|dc| dc['description'] == 'Intervention, Order: Hospice care ambulatory' }
  end
  
  test "derive entry with coded data" do
    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@p1_diagnosis_diabetes_sdc, @p1_valuesets)
    assert entry, "Should have created an entry with  coded data"
    assert_equal Condition, entry.class, "should have created and Encounter object"
    assert_equal @p1_diagnosis_diabetes_sdc["codes"], entry.codes
  end

  test "data criteria defines entry type for derive_entry" do
    @data_criteria_communication = HQMF::DataCriteria.get_settings_for_definition('communication_from_patient_to_provider','')
    entry = Measures::PatientBuilder.derive_entry(@data_criteria_communication,@p1_diagnosis_diabetes_sdc,@p1_valuesets)
    assert entry, "Should have created an entry with communication data_criteria"
    assert_equal Communication, entry.class, "should have created a Communication object"

    entry = Measures::PatientBuilder.derive_entry(@data_criteria_encounter,@p1_diagnosis_diabetes_sdc,@p1_valuesets)
    assert entry, "Should have created an entry with encounter data_criteria"
    assert_equal Encounter, entry.class, "should have created an Encounter object"

    entry = Measures::PatientBuilder.derive_entry(@data_criteria_labtest,@p1_diagnosis_diabetes_sdc,@p1_valuesets)
    assert entry, "Should have created an entry with labtest data_criteria"
    assert_equal VitalSign, entry.class, "should have created a VitalSign object"
  end

  test "derive negation" do
    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@p2_intervention_order_sdc, @p2_valuesets)
    assert  !entry.negation_ind, "entry negation should be false before call to derive_negation"
    assert entry.negation_reason.nil?, "negation should have no codes before call to derive_negation"

    # get first concept from fixture
    negation_code_list_id = @p2_intervention_order_sdc['negation_code_list_id']
    vs_emergency_department_visit = @p2_valuesets.select{|key,value| key==negation_code_list_id}.first[1]
    the_concept = vs_emergency_department_visit['concepts'][0]

    Measures::PatientBuilder.derive_negation(entry,@p2_intervention_order_sdc,@p2_valuesets)
    assert entry.negation_ind, "entry negation should be true after call to derive_negation"
    code ={"code_system" => the_concept['code_system_name'] , "code" => the_concept['code']}
    assert_equal code, entry.negation_reason, "Negation codes should have been auto selected"
  end

  test "derive entry with facility" do
    entry = Measures::PatientBuilder.derive_entry(@data_criteria_encounter,@p1_wellness_visit_sdc, @p1_valuesets)
    assert entry, "Should have created an entry"
    assert_equal Encounter, entry.class, "should have created and Encounter object"
    assert !@p1_wellness_visit_sdc['field_values']['FACILITY_LOCATION'].nil?, "Wellness visit contains facility location"
    Measures::PatientBuilder.derive_field_values(entry, @p1_wellness_visit_sdc['field_values'],@p1_valuesets)
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
    entry = Measures::PatientBuilder.derive_entry(@data_criteria_labtest, @p1_lab_test_kidney_sdc, @p1_valuesets)
    assert entry, "Should have created an entry"
    # LaboratoryTestPerformed is a VitalSign because its patient_api_function defined in HDS/data_criteria.json
    # maps to the patient_api_extention hQuery.Patient::laboratoryTests = -> this.results().concat(this.vitalSigns())
    assert_equal VitalSign, entry.class, "should have created Laboratory object"
    assert !@p1_lab_test_kidney_sdc['field_values']['COMPONENT'].nil?, "Lab test contains component"
    # validate fixture
    comp_code_list_id = @p1_lab_test_kidney_sdc['field_values']['COMPONENT']['values'][0]['code_list_id']
    assert_equal '2.16.840.1.113883.3.464.1003.109.12.1028', comp_code_list_id, "Fixture out of date with test"
    vs_kidney_failure = @p1_valuesets.select{|key,value| key=='2.16.840.1.113883.3.464.1003.109.12.1028'}.first[1]
    kidney_failure_concept = vs_kidney_failure['concepts'][0]
    Measures::PatientBuilder.derive_field_values(entry, @p1_lab_test_kidney_sdc['field_values'], @p1_valuesets)
    assert !entry.components.nil?, "components collection should have been created"
    assert_equal 2, entry.components['values'].length
    # A component has a code and a result
    code = entry.components['values'][1]['code']
    result = entry.components['values'][1]['result']
    assert_equal kidney_failure_concept['code_system_name'], code['code_system']
    assert_equal kidney_failure_concept['code'], code['code']
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
    entry = Measures::PatientBuilder.derive_entry(@data_criteria_labtest,@p1_lab_test_kidney_sdc, @p1_valuesets)
    assert entry.values.nil? || entry.values.empty? , "There should be no values"
    Measures::PatientBuilder.derive_values(entry,@p1_lab_test_kidney_sdc["value"],@p1_valuesets)
    expected_length = @p1_lab_test_kidney_sdc["value"].length
    assert_equal expected_length, entry.values.length, "Should have created #{expected_length} values"
    result_code_list_id = @p1_lab_test_kidney_sdc["value"][0]["code_list_id"]
    assert_equal Measures::PatientBuilder.select_codes(result_code_list_id, @p1_valuesets), entry.values[0].codes, "Codes should have matched select_codes"

    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@p1_lab_test_1xx_sdc, @p1_valuesets)
    assert entry.values.nil? || entry.values.empty? , "There should be no values"
    Measures::PatientBuilder.derive_values(entry,@p1_lab_test_1xx_sdc["value"],@p1_valuesets)
    expected_length = @p1_lab_test_1xx_sdc["value"].length
    assert_equal expected_length, entry.values.length, "Should have created #{expected_length} values"
    assert_equal @p1_lab_test_1xx_sdc["value"][0]["value"], entry.values[0].scalar
    assert_equal @p1_lab_test_1xx_sdc["value"][0]["unit"], entry.values[0].units
  end

  test "derive field"  do
    entry = Measures::PatientBuilder.derive_entry(@data_criteria,@p1_diagnosis_diabetes_sdc, @p1_valuesets)
    assert entry.values.nil? || entry.values.empty? , "There should be no values"
    Measures::PatientBuilder.derive_field_values(entry,@p1_diagnosis_diabetes_sdc["field_values"],@p1_valuesets)
    assert !entry.ordinality.nil?, "Should have created an ordinal filed value"
    entry_code_id = @p1_diagnosis_diabetes_sdc['field_values']['ORDINAL']['code_list_id']
    expected_code = Measures::PatientBuilder.select_code(entry_code_id, @p1_valuesets)
    expected_code['title'] = @p1_diagnosis_diabetes_sdc['field_values']['ORDINAL']['title']
    assert_equal(expected_code, entry.ordinality, "Should have created an ordinal filed value")
  end

  test "get value sets" do
    vs_oids = Measures::PatientBuilder.get_vs_oids(@p1_diagnosis_diabetes_sdc)
    assert vs_oids.include?(@p1_diagnosis_diabetes_sdc['code_list_id']), "Missing code from SDC's code_list_id"
    assert vs_oids.include?(@p1_diagnosis_diabetes_sdc['field_values']['ORDINAL']['code_list_id']), "Missing code from field value"

    vs_oids = Measures::PatientBuilder.get_vs_oids(@p2_intervention_order_sdc)
    assert vs_oids.include?(@p2_intervention_order_sdc['negation_code_list_id']), "Missing code from SDC's negation_code_list_id"

    vs_oids = Measures::PatientBuilder.get_vs_oids(@p1_wellness_visit_sdc)
    assert vs_oids.include?(@p1_wellness_visit_sdc['field_values']['FACILITY_LOCATION']['values'][0]['code_list_id']), "Missing code from facility location"

    vs_oids = Measures::PatientBuilder.get_vs_oids(@p1_lab_test_kidney_sdc)
    assert vs_oids.include?(@p1_lab_test_kidney_sdc['field_values']['COMPONENT']['values'][0]['code_list_id']), "Missing code from componenet"
    assert vs_oids.include?(@p1_lab_test_kidney_sdc['value'][0]['code_list_id']), "Missing code from coded result"
  end

end
