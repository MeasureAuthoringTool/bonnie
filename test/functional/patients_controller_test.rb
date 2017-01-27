require 'test_helper'

class PatientsControllerTest  < ActionController::TestCase
include Devise::TestHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(measures_set, users_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    @measure_two = Measure.where({"cms_id" => "CMS104v2"}).first
    @measure_three = Measure.where({"cms_id" => "CMS128v2"}).first
    sign_in @user
  end

  test "get all patients" do
    records_set = File.join("records","base_set")
    collection_fixtures(records_set)
    associate_user_with_measures(@user, Measure.all)
    associate_measures_with_patients([@measure, @measure_two, @measure_three], Record.all)
    associate_user_with_patients(@user, Record.all)

    get :index
    assert_equal 4, JSON.parse(response.body).count

  end

  test "create" do

    assert_equal 0, Record.count
    @patient = {'first'=> 'Betty',
     'last'=> 'Boop',
     'gender'=> 'F',
     'expired'=> 'true' ,
     'birthdate'=> "1930-10-17",
     'ethnicity'=> 'B',
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'source_data_criteria' => [{"id" => 'EncounterPerformedPsychVisitDiagnosticEvaluation', "status"=>"performed", "definition"=>"encounter", "start_date"=>1333206000000,"end_date"=>1333206000000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.hqmf_set_id,
     'expected_values' => [{"measure_id" => @measure.hqmf_set_id, 'population_index' => 0, 'IPP' => 1, 'DENOM' => 0, 'NUMER' => 0}],
     'calc_results'=> [{"measure_id" => @measure.hqmf_set_id, 'population_index' => 0, 'IPP' => 1, 'DENOM' => 0, 'NUMER' => 0}]}

    post :create, @patient
    assert_response :success
    assert_equal 1, Record.count
    r = Record.first
    assert_equal 'Betty', r.first
    assert_equal 'Boop', r.last
    assert_equal 'F', r.gender
    assert_equal 2, r.source_data_criteria.length
    assert_equal 'EncounterPerformedPsychVisitDiagnosticEvaluation', r.source_data_criteria[0]["id"]
    assert_equal 1, r.encounters.length
    assert_equal [{"measure_id"=>"E35791DF-5B25-41BB-B260-673337BC44A8", "population_index"=>"0", "IPP"=>"1", "DENOM"=>"0", "NUMER"=>"0", "status"=>"pass"}], r.calc_results, "Checking that calc_status worked."
    assert_equal false, r.has_measure_history
    assert_equal false, r.results_exceed_storage
    assert_equal nil, r.condensed_calc_results
    assert_equal 128, r.results_size
    json = JSON.parse(response.body)

    assert_equal 'Betty', json['first']
    assert_equal 'Boop', json['last']
    assert_equal 'F', json["gender"]
    assert_equal 2, json['source_data_criteria'].length
    assert_equal 'EncounterPerformedPsychVisitDiagnosticEvaluation', json['source_data_criteria'][0]["id"]
    assert_equal 1, json["encounters"].length
  end

  test "create expected does not match calculated" do

    assert_equal 0,Record.count
    @patient = {
      'first'=> 'Bobby', 
     'last'=> 'Boop', 
     'gender'=> 'M', 
     'expired'=> 'true' ,
     'birthdate'=> "1930-10-17", 
     'ethnicity'=> 'B', 
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'source_data_criteria' => [{"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation', "status"=>"performed", "definition"=>"encounter", "start_date"=>1341648000000,"end_date"=>1341648900000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.hqmf_set_id,
     'expected_values' => [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0}],
     'calc_results'=> [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>1, 'NUMER'=>1}]}

    post :create, @patient
    assert_response :success
    assert_equal 1,Record.count
    r = Record.first
    assert_equal "Bobby", r.first
    assert_equal 'Boop', r.last
    assert_equal "M", r.gender
    assert_equal 2, r.source_data_criteria.length
    assert_equal 'EncounterPerformedPsychVisitDiagnosticEvaluation', r.source_data_criteria[0]["id"]
    assert_equal 1, r.encounters.length
    assert_equal "fail", r.calc_results[0]['status'], "Checking that calc_status worked."
    json = JSON.parse(response.body)

    assert_equal "Bobby", json['first']
    assert_equal 'Boop', json['last']
    assert_equal "M", json["gender"]
    assert_equal 2, json['source_data_criteria'].length
    assert_equal 'EncounterPerformedPsychVisitDiagnosticEvaluation', json['source_data_criteria'][0]["id"]
    assert_equal 1, json["encounters"].length
  end

  test "update" do

    assert_equal 0,Record.count
    
    @patient = {'first'=> 'Abby', 
     'last'=> 'Boop', 
     'gender'=> 'X', 
     'expired'=> 'true' ,
     'birthdate'=> 48600, 
     'ethnicity'=> 'B', 
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'source_data_criteria' => [{"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation', "status"=>"performed", "definition"=>"encounter", "start_date"=>1341648000000,"end_date"=>1341648900000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.hqmf_set_id,
     'expected_values' => [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0}],
     'calc_results'=> [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0}]}

    post :create, @patient
    assert_response :success
    assert_equal 1,Record.count
    
    patient = Record.first
    assert_equal 1, patient.history_tracks.count
    assert_equal 0, patient.history_tracks[0]['original'].count

    @patient['first'] = 'Betty'
    @patient['last'] = 'Boop'
    @patient['id'] = patient.id.to_s
    @patient['_id'] = patient.id.to_s
    @patient['gender'] = 'F'
    @patient['birthdate']= 9948600
    
    post :update,@patient
    assert_response :success
    assert_equal 1, Record.count
    r = Record.first
    assert_equal 'Betty', r.first
    assert_equal 'Boop', r.last
    assert_equal 'F', r.gender
    assert_equal 2, r.source_data_criteria.length
    assert_equal 'EncounterPerformedPsychVisitDiagnosticEvaluation', r.source_data_criteria[0]["id"]
    assert_equal 1, r.encounters.length
    
    # Test that the history tracking is working
    assert_equal 2, r.history_tracks.count
    assert_equal 2, r.history_tracks[1]['modified'].count
    
    json = JSON.parse(response.body)

    assert_equal 'Betty', json['first']
    assert_equal 'Boop', json['last']
    assert_equal 'F', json["gender"]
    assert_equal 2, json['source_data_criteria'].length
    assert_equal 'EncounterPerformedPsychVisitDiagnosticEvaluation', json['source_data_criteria'][0]["id"]
    assert_equal 1, json["encounters"].length
  end

  test "exercise history tracking" do

    assert_equal 0,Record.count
    
    @patient = {'first'=> 'Abby', 
     'last'=> 'Boop', 
     'gender'=> 'X', 
     'expired'=> 'true' ,
     'birthdate'=> 48600, 
     'ethnicity'=> 'B', 
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'source_data_criteria' => [{"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation', "status"=>"performed", "definition"=>"encounter", "start_date"=>1341648000000,"end_date"=>1341648900000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492", 'criteria_id'=>1}],
     'measure_id' => @measure.hqmf_set_id,
     'expected_values' => [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0}],
     'calc_results'=> [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0}]}

    post :create, @patient
    assert_response :success
    assert_equal 1,Record.count
    
    patient = Record.first
    assert_equal 1, patient.history_tracks.count
    assert_equal 'pass', patient.calc_results[0]['status']

    @patient['first'] = 'Betty'
    @patient['last'] = 'Boop'
    @patient['id'] = patient.id.to_s
    @patient['_id'] = patient.id.to_s
    @patient['gender'] = 'F'
    @patient['birthdate']= 9948600

    post :update,@patient
    assert_response :success
    assert_equal 1, Record.count
    r = Record.first
    assert_equal 'Betty', r.first
    assert_equal 'Boop', r.last
    assert_equal 'F', r.gender
    assert_equal 2, r.source_data_criteria.length
    assert_equal 'EncounterPerformedPsychVisitDiagnosticEvaluation', r.source_data_criteria[0]["id"]
    assert_equal 1, r.encounters.length
    
    # Test that the history tracking is working
    assert_equal 2, r.history_tracks.count
    # While the name changed only the DOB and gender should be in the changes recorded
    assert_equal 2, r.history_tracks[1]['modified'].count
    assert_equal 'pass', r.calc_results[0]['status']
    

    @patient['source_data_criteria'] = [{"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation',"status"=>"performed", "definition"=>"encounter", "start_date"=>1341648000000,"end_date"=>1341648900000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492", "coded_entry_id"=>BSON::ObjectId.new, 'criteria_id'=>1}]

    post :update, @patient
    assert_response :success
    # Adding coded_entry_id should not increase the number of history tracks.
    assert_equal 2, r.history_tracks.count

    @patient['expected_values'] = [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>1, 'NUMER'=>0}]
     
    post :update, @patient
    assert_response :success
    # Changing the expected results should create a new history track. Should also change the status from pass to fail.
    r = Record.last
    assert_equal 3, r.history_tracks.count
    assert_equal "fail", r.calc_results[0]['status']

    @patient['source_data_criteria'] = [{"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation',"status"=>"performed", "definition"=>"encounter", "start_date"=>1341648000000,"end_date"=>1341735300000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492", "coded_entry_id"=>BSON::ObjectId.new, 'criteria_id'=>1}]

    post :update, @patient
    assert_response :success
    
    r = Record.last
    #  Check that the date change in the encounter is recorded
    assert_equal 4, r.history_tracks.count
    assert_equal 1, r.history_tracks[3]['original']['source_data_criteria'].count
    assert_equal 1, r.history_tracks[3]['modified']['source_data_criteria'].count
    
    @patient['source_data_criteria'] = [{"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation',"status"=>"performed", "definition"=>"encounter", "start_date"=>1341648000000,"end_date"=>1341735300000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492",
     "coded_entry_id"=>BSON::ObjectId.new, 'criteria_id'=>1}, {"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation',"status"=>"performed", "definition"=>"encounter", "start_date"=>1341448000000,"end_date"=>1341535300000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492",
     "coded_entry_id"=>BSON::ObjectId.new, 'criteria_id'=>2}]

    post :update, @patient
    assert_response :success
    
    # Adding a second encounter
    r = Record.last
    #  Check that the date change in the encounter is recorded
    assert_equal 5, r.history_tracks.count
    assert_equal 0, r.history_tracks[4]['original']['source_data_criteria'].count
    assert_equal 1, r.history_tracks[4]['modified']['source_data_criteria'].count

  end

  test "exceeding the size limit" do
    assert_equal 0,Record.count

    @patient = {'first'=> 'Abby', 
     'last'=> 'Boop', 
     'gender'=> 'X', 
     'expired'=> 'true' ,
     'birthdate'=> 48600, 
     'ethnicity'=> 'B', 
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'source_data_criteria' => [{"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation', "status"=>"performed", "definition"=>"encounter", "start_date"=>1341648000000,"end_date"=>1341648900000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492", 'criteria_id'=>1}],
     'measure_id' => @measure.hqmf_set_id,
     'expected_values' => [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0}],
     'calc_results'=> [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0}]}

    post :create, @patient
    assert_response :success
    assert_equal 1,Record.count
    
    patient = Record.first
    assert_equal 1, patient.history_tracks.count
    assert_equal 'pass', patient.calc_results[0]['status']

    # Increase the size of the rationale so that it exceeds the size limit
    @patient['first'] = 'Betty'
    @patient['last'] = 'Boop'
    @patient['id'] = patient.id.to_s
    @patient['_id'] = patient.id.to_s
    @patient['gender'] = 'F'
    @patient['birthdate']= 9948600
    @patient['calc_results'] = [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0, "rationale"=>'X' * (1024 * 1024 * 12), "finalSpecifics"=>'Z' * (1024)}]

    
    post :update,@patient
    assert_response :success
    assert_equal 1, Record.count

    r = Record.first
    assert_equal 2, r.history_tracks.count
    assert_equal true, r.results_exceed_storage
    assert_equal 'pass', r.condensed_calc_results[0]['status']
    assert_equal nil, r.condensed_calc_results[0]['rationale']
    assert_equal nil, r.condensed_calc_results[0]['finalSpecifics']
    assert_equal false, r.calc_results?

    @patient['calc_results'] = [{"measure_id"=>@measure.hqmf_set_id, 'population_index'=>0, 'IPP'=>1, 'DENOM'=>0, 'NUMER'=>0, "rationale"=>'X' * (1024), "finalSpecifics"=>'Z' * (1024)}]
    
    post :update,@patient
    assert_response :success
    assert_equal 1, Record.count

    r = Record.first
    assert_equal 3, r.history_tracks.count
    assert_equal false, r.condensed_calc_results?
    assert_equal true, r.calc_results?
    assert_equal true, r.calc_results[0]['rationale'].length > 0
    assert_equal true, r.calc_results[0]['finalSpecifics'].length > 0
    assert_equal false, r.results_exceed_storage

    # Now test that history_tracks are cleaned up when the patient is 
    delete :destroy, {id: r.id}
    assert_response :success
    assert_equal 0, r.history_tracks.count

  end

  test "materialize" do
   assert_equal 0, Record.count
    @patient = {'first'=> 'Betty',
     'last'=> 'Boop',
     'gender'=> 'F',
     'expired'=> 'true' ,
     'birthdate'=> "1930-10-17",
     'ethnicity'=> 'B',
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'source_data_criteria' => [{"id"=>'EncounterPerformedPsychVisitDiagnosticEvaluation',"status"=>"performed", "definition"=>"encounter", "start_date"=>1333206000000,"end_date"=>1333206000000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.hqmf_set_id}

    post :materialize, @patient
    assert_response :success
    assert_equal 0, Record.count

    json = JSON.parse(response.body)

    assert_equal 'Betty', json['first']
    assert_equal 'Boop', json['last']
    assert_equal 'F', json["gender"]
    assert_equal 2, json['source_data_criteria'].length
    assert_equal 'EncounterPerformedPsychVisitDiagnosticEvaluation', json['source_data_criteria'][0]["id"]
    assert_equal 1, json["encounters"].length
  end

  test "destroy" do
    records_set = File.join("records","base_set")
    collection_fixtures(records_set)
    associate_user_with_patients(@user, Record.all)
    patient = Record.first
    assert_equal 4, @user.records.count
    delete :destroy, {id: patient.id}
    assert_response :success
    assert_equal 3, @user.records.count
    patient = Record.where({id: patient.id}).first
    assert_nil patient

  end

  test "export patients" do
    records_set = File.join("records","base_set")
    collection_fixtures(records_set)
    associate_user_with_patients(@user, Record.all)
    associate_measures_with_patients([@measure, @measure_two], Record.all)
    get :qrda_export, hqmf_set_id: @measure.hqmf_set_id
    assert_response :success
    assert_equal 'application/zip', response.header['Content-Type']
    assert_equal "attachment; filename=\"#{@measure.cms_id}_patient_export.zip\"", response.header['Content-Disposition']
    assert_equal 'fileDownload=true; path=/', response.header['Set-Cookie']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']

    zip_path = File.join('tmp', 'test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      assert_equal 4, zip_file.glob(File.join('qrda','**.xml')).length
      html_files = zip_file.glob(File.join('html', '**.html'))
      assert_equal 4, html_files.length
      html_files.each do |html_file| # search each HTML file to ensure alternate measure data is not included
        doc = Nokogiri::HTML(html_file.get_input_stream.read)
        xpath = "//b[contains(text(), 'SNOMED-CT:')]/i/span[@onmouseover and contains(text(), '417005')]"
        assert_equal 0, doc.xpath(xpath).length
      end
    end
    File.delete(zip_path)

  end

  test "export patients portfolio" do
    records_set = File.join("records", "base_set")
    collection_fixtures(records_set)
    # Remove the patients that were loaded for testing measure history
    patients = Record.where(measure_ids: 'C0D72444-7C26-4863-9B51-8080F8928A85')
    patients.each do |pat|
      pat.delete
      end
    associate_user_with_patients(@user, Record.all)
    associate_measures_with_patients([@measure, @measure_two], Record.all)
    @user.grant_portfolio()
    get :qrda_export, hqmf_set_id: @measure.hqmf_set_id
    assert_response :success
    assert_equal 'application/zip', response.header['Content-Type']
    assert_equal "attachment; filename=\"#{@measure.cms_id}_patient_export.zip\"", response.header['Content-Disposition']
    assert_equal 'fileDownload=true; path=/', response.header['Set-Cookie']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']

    zip_path = File.join('tmp', 'test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      assert_equal 4, zip_file.glob(File.join('qrda', '**.xml')).length
      html_files = zip_file.glob(File.join('html', '**.html'))
      assert_equal 4, html_files.length
      html_files.each do |html_file| # search each HTML file to ensure alternate measure data is not included
        doc = Nokogiri::HTML(html_file.get_input_stream.read)
        xpath = "//b[contains(text(), 'SNOMED-CT:')]/i/span[@onmouseover and contains(text(), '417005')]"
        assert_operator doc.xpath(xpath).length, :>, 0
      end
    end
    File.delete(zip_path)

  end

  test "excel export patients" do
    records_set = File.join("records","base_set")
    collection_fixtures(records_set)
    associate_user_with_patients(@user, Record.all)
    associate_measures_with_patients([@measure_two], Record.all)
    get :excel_export, hqmf_set_id: @measure.hqmf_set_id
    assert_response :success
    # TODO Get measures to pass the opposite of these tests. (Assert_equal)
    assert_not_equal 'application/xlsx', response.header['Content-Type']
    # assert_not_equal "attachment; filename=\"#{measure.cms_id}.xlsx\"", response.header['Content-Disposition']
    assert_not_equal 'fileDownload=true; path=/', response.header['Set-Cookie']
    assert_not_equal 'binary', response.header['Content-Transfer-Encoding']
  end


end
