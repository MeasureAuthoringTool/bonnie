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
     'source_data_criteria' => [{"id"=>"EncounterPerformedPsychVisitDiagnosticEvaluation", "status"=>"performed", "definition"=>"encounter", "start_date"=>1333206000000,"end_date"=>1333206000000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.hqmf_set_id}

    post :create, @patient
    assert_response :success
    assert_equal 1, Record.count
    r = Record.first
    assert_equal "Betty", r.first
    assert_equal "Boop", r.last
    assert_equal "F", r.gender
    assert_equal 2, r.source_data_criteria.length
    assert_equal "EncounterPerformedPsychVisitDiagnosticEvaluation", r.source_data_criteria[0]["id"]
    assert_equal 1, r.encounters.length
    json = JSON.parse(response.body)

    assert_equal "Betty", json["first"]
    assert_equal "Boop", json["last"]
    assert_equal "F", json["gender"]
    assert_equal 2, json["source_data_criteria"].length
    assert_equal "EncounterPerformedPsychVisitDiagnosticEvaluation", json["source_data_criteria"][0]["id"]
    assert_equal 1, json["encounters"].length
  end


  test "update" do

    assert_equal 0, Record.count
    patient = Record.new
    patient.user = @user
    patient.save!

    @patient = {
      "id" => patient.id.to_s,
      "_id" => patient.id.to_s,
      'first'=> 'Betty',
     'last'=> 'Boop',
     'gender'=> 'F',
     'expired'=> 'true' ,
     'birthdate'=> "1930-10-17",
     'ethnicity'=> 'B',
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'source_data_criteria' => [{"id"=>"EncounterPerformedPsychVisitDiagnosticEvaluation","status"=>"performed", "definition"=>"encounter", "start_date"=>1333206000000,"end_date"=>1333206000000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.hqmf_set_id}

    post :update,@patient
    assert_response :success
    assert_equal 1, Record.count
    r = Record.first
    assert_equal "Betty", r.first
    assert_equal "Boop", r.last
    assert_equal "F", r.gender
    assert_equal 2, r.source_data_criteria.length
    assert_equal "EncounterPerformedPsychVisitDiagnosticEvaluation", r.source_data_criteria[0]["id"]
    assert_equal 1, r.encounters.length
    json = JSON.parse(response.body)

    assert_equal "Betty", json["first"]
    assert_equal "Boop", json["last"]
    assert_equal "F", json["gender"]
    assert_equal 2, json["source_data_criteria"].length
    assert_equal "EncounterPerformedPsychVisitDiagnosticEvaluation", json["source_data_criteria"][0]["id"]
    assert_equal 1, json["encounters"].length
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
     'source_data_criteria' => [{"id"=>"EncounterPerformedPsychVisitDiagnosticEvaluation","status"=>"performed", "definition"=>"encounter", "start_date"=>1333206000000,"end_date"=>1333206000000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"code_list_id"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.hqmf_set_id}

    post :materialize, @patient
    assert_response :success
    assert_equal 0, Record.count

    json = JSON.parse(response.body)

    assert_equal "Betty", json["first"]
    assert_equal "Boop", json["last"]
    assert_equal "F", json["gender"]
    assert_equal 2, json["source_data_criteria"].length
    assert_equal "EncounterPerformedPsychVisitDiagnosticEvaluation", json["source_data_criteria"][0]["id"]
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
    records_set = File.join("records","base_set")
    collection_fixtures(records_set)
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
    calc_results = '{"c10":{"c20":{"statement_results":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"NA","Stratification2":"NA","Initial Population":"FALSE","Measure Population":"UNHIT","Measure Population Exclusion":"UNHIT","RelatedEDVisit":"UNHIT","MeasureObservation":"UNHIT"}},"criteria":{"IPP":0,"MSRPOPL":0,"values":[],"MSRPOPLEX":0}},"c39":{"statement_results":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"NA","Stratification2":"NA","Initial Population":"TRUE","Measure Population":"UNHIT","Measure Population Exclusion":"TRUE","RelatedEDVisit":"UNHIT","MeasureObservation":"UNHIT"}},"criteria":{"IPP":1,"MSRPOPL":1,"values":[{"low":null,"high":null}],"MSRPOPLEX":1}}},"c11":{"c20":{"statement_results":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"FALSE","Stratification2":"NA","Initial Population":"UNHIT","Measure Population":"UNHIT","Measure Population Exclusion":"UNHIT","RelatedEDVisit":"UNHIT","MeasureObservation":"UNHIT"}},"criteria":{"STRAT":0,"IPP":0,"MSRPOPL":0,"values":0,"MSRPOPLEX":0}},"c39":{"statement_results":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"TRUE","Stratification2":"NA","Initial Population":"TRUE","Measure Population":"UNHIT","Measure Population Exclusion":"TRUE","RelatedEDVisit":"UNHIT","MeasureObservation":"UNHIT"}},"criteria":{"STRAT":1,"IPP":1,"MSRPOPL":1,"values":[{"low":null,"high":null}],"MSRPOPLEX":1}}},"c12":{"c20":{"statement_results":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"NA","Stratification2":"TRUE","Initial Population":"FALSE","Measure Population":"UNHIT","Measure Population Exclusion":"UNHIT","RelatedEDVisit":"UNHIT","MeasureObservation":"UNHIT"}},"criteria":{"STRAT":1,"IPP":0,"MSRPOPL":0,"values":0,"MSRPOPLEX":0}},"c39":{"statement_results":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"NA","Stratification2":"FALSE","Initial Population":"UNHIT","Measure Population":"UNHIT","Measure Population Exclusion":"UNHIT","RelatedEDVisit":"UNHIT","MeasureObservation":"UNHIT"}},"criteria":{"STRAT":0,"IPP":0,"MSRPOPL":0,"values":0,"MSRPOPLEX":0}}}}'
    patient_details = '{"c20":{"first":"a","last":"a","expected_values":[{"measure_id":"28AC347D-2F91-4A0C-9395-2602134BAA89","population_index":0,"IPP":0,"MSRPOPL":0,"MSRPOPLEX":0,"OBSERV_UNIT":" mins"},{"measure_id":"28AC347D-2F91-4A0C-9395-2602134BAA89","population_index":1,"STRAT":0,"IPP":0,"MSRPOPL":0,"MSRPOPLEX":0,"OBSERV_UNIT":" mins"},{"measure_id":"28AC347D-2F91-4A0C-9395-2602134BAA89","population_index":2,"STRAT":0,"IPP":0,"MSRPOPL":0,"MSRPOPLEX":0,"OBSERV_UNIT":" mins"}],"birthdate":805017600,"expired":null,"deathdate":null,"ethnicity":"2186-5","race":"1002-5","gender":"M"},"c39":{"first":"b","last":"b","expected_values":[{"measure_id":"28AC347D-2F91-4A0C-9395-2602134BAA89","population_index":0,"IPP":0,"MSRPOPL":0,"MSRPOPLEX":0,"OBSERV_UNIT":" mins","OBSERV":[null]},{"measure_id":"28AC347D-2F91-4A0C-9395-2602134BAA89","population_index":1,"STRAT":0,"IPP":0,"MSRPOPL":0,"MSRPOPLEX":0,"OBSERV_UNIT":" mins"},{"measure_id":"28AC347D-2F91-4A0C-9395-2602134BAA89","population_index":2,"STRAT":0,"IPP":0,"MSRPOPL":0,"MSRPOPLEX":0,"OBSERV_UNIT":" mins"}],"birthdate":352627200,"expired":null,"deathdate":null,"ethnicity":"2186-5","race":"1002-5","gender":"M"}}'
    population_details = '{"c10":{"title":"Population Criteria Section","statement_relevance":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"NA","Stratification2":"NA","Initial Population":"TRUE","Measure Population":"FALSE","Measure Population Exclusion":"FALSE","RelatedEDVisit":"FALSE","MeasureObservation":"FALSE"}},"criteria":["IPP","MSRPOPL","MSRPOPLEX","OBSERV","index"]},"c11":{"title":"Stratification 1","statement_relevance":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"TRUE","Stratification2":"NA","Initial Population":"FALSE","Measure Population":"FALSE","Measure Population Exclusion":"FALSE","RelatedEDVisit":"FALSE","MeasureObservation":"FALSE"}},"criteria":["IPP","MSRPOPL","MSRPOPLEX","OBSERV","stratification","STRAT","population_index","stratification_index","index"]},"c12":{"title":"Stratification 2","statement_relevance":{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"Patient":"NA","SDE Ethnicity":"NA","SDE Payer":"NA","SDE Race":"NA","SDE Sex":"NA","Inpatient Encounter":"TRUE","Startification1":"NA","Stratification2":"TRUE","Initial Population":"TRUE","Measure Population":"FALSE","Measure Population Exclusion":"FALSE","RelatedEDVisit":"FALSE","MeasureObservation":"FALSE"}},"criteria":["IPP","MSRPOPL","MSRPOPLEX","OBSERV","stratification","STRAT","population_index","stratification_index","index"]}}'
    statement_details = '{"MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients":{"SDE Ethnicity":"define \"SDE Ethnicity\": [\"Patient Characteristic Ethnicity\": \"Ethnicity\" ]","SDE Payer":" define \"SDE Payer\": [\"Patient Characteristic Payer\": \"Payer\" ]","SDE Race":" define \"SDE Race\": [\"Patient Characteristic Race\": \"Race\" ]","SDE Sex":" define \"SDE Sex\": [\"Patient Characteristic Sex\": \"ONC Administrative Sex\" ]","Inpatient Encounter":" define \"Inpatient Encounter\": [\"Encounter, Performed\": \"Encounter Inpatient\" ] Encounter\n\t\twhere Encounter.lengthOfStay <= 120 days\n\t\t\tand Encounter.relevantPeriod ends during \"Measurement Period\"","Startification1":" define \"Startification1\": \"Inpatient Encounter\" Encounter \nwhere not ( Encounter.principalDiagnosis in \"Psychiatric/Mental Health Patient\" )","Stratification2":" define \"Stratification2\": \"Inpatient Encounter\" Encounter \nwhere Encounter.principalDiagnosis in \"Psychiatric/Mental Health Patient\"","Initial Population":" define \"Initial Population\": \"Inpatient Encounter\" Encounter \nwith [\"Encounter, Performed\": \"Emergency Department Visit\" ] ED \nsuch that ED.relevantPeriod ends 1 hour or less before start of Encounter.relevantPeriod","Measure Population":" define \"Measure Population\": \"Initial Population\"","Measure Population Exclusion":" define \"Measure Population Exclusion\": \"Inpatient Encounter\" Encounter \nwith [\"Encounter, Performed\": \"Emergency Department Visit\" ] ED \nsuch that ED.relevantPeriod ends 1 hour or less before start of Encounter.relevantPeriod \nand ED.admissionSource in \"Hospital Settings\"","RelatedEDVisit":" define function \"RelatedEDVisit\"(\"Encounter\" \"Encounter, Performed\" ): Last(\n    [\"Encounter, Performed\": \"Emergency Department Visit\" ] ED\n      where ED.relevantPeriod ends 1 hour or less before start of Encounter.relevantPeriod\n      sort by start of relevantPeriod\n  )","MeasureObservation":" define function \"MeasureObservation\"(\"Encounter\" \"Encounter, Performed\" ): duration in minutes of \"RelatedEDVisit\"( Encounter ).locationPeriod"}}'
    get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test"
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    # assert_not_equal "attachment; filename=\"#{measure.cms_id}.xlsx\"", response.header['Content-Disposition']
    assert_equal 'fileDownload=true; path=/', response.header['Set-Cookie']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
  end


end
