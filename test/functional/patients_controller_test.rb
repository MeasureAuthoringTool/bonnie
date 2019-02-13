require 'test_helper'

class PatientsControllerTest  < ActionController::TestCase
include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    cql_measures_set = File.join("cql_measures", "**")
    collection_fixtures(cql_measures_set, users_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, CQM::Measure.all)
    @measure = CQM::Measure.where({"cms_id" => "CMS134v6"}).first
    sign_in @user
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

  test "create patient for component measure of composite measure" do
    assert_equal 0, Record.count
    @patient = {'first'=> 'Betty',
     'last'=> 'Boop',
     'gender'=> 'F',
     'birthdate'=> "1930-10-17",
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'measure_id' => "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&3000797E-11B1-4F62-A078-341A4002A11C"}

    expected_measure_ids = ["244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&3000797E-11B1-4F62-A078-341A4002A11C",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&920D5B27-DF5A-4770-BD60-FC4EE251C4D2",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&7B905B21-D904-454F-885B-9CE5D19674E3",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&BA108B7B-90B4-4692-B1D0-5DB554D2A1A2",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&5B20AFEA-D4AF-4F7A-A5A3-F1F6165B9E5F",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&F03324C2-9147-457B-BC34-811BB7859C91",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&E22EA997-4EC1-4ED2-876C-3671099CB325",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"]
    post :create, @patient
    assert_response :success
    assert_equal 1, Record.count
    r = Record.first
    assert_equal "Betty", r.first
    assert_equal "Boop", r.last
    assert_equal expected_measure_ids.sort, r.measure_ids.sort
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
    records_set = File.join("records","core_measures", "CMS134v6")
    collection_fixtures(records_set)
    associate_user_with_patients(@user, Record.all)
    patient = Record.first
    assert_equal 3, @user.records.count
    delete :destroy, {id: patient.id}
    assert_response :success
    assert_equal 2, @user.records.count
    patient = Record.where({id: patient.id}).first
    assert_nil patient
  end

  test "export patients" do
    records_set = File.join("records", "core_measures", "CMS134v6")
    collection_fixtures(records_set)
    associate_user_with_patients(@user, Record.all)
    associate_measure_with_patients(@measure, Record.all)

    get :qrda_export, hqmf_set_id: @measure.hqmf_set_id, isCQL: 'true'
    assert_response :success
    assert_equal 'application/zip', response.header['Content-Type']
    assert_equal "attachment; filename=\"#{@measure.cms_id}_patient_export.zip\"", response.header['Content-Disposition']
    assert_equal 'fileDownload=true; path=/', response.header['Set-Cookie']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']

    Dir.mkdir(Rails.root.join('tmp')) unless Dir.exist?(Rails.root.join('tmp'))
    zip_path = File.join('tmp', 'test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      assert_equal 3, zip_file.glob(File.join('qrda','**.xml')).length
      html_files = zip_file.glob(File.join('html', '**.html'))
      assert_equal 3, html_files.length
      html_files.each do |html_file| # search each HTML file to ensure alternate measure data is not included
        doc = Nokogiri::HTML(html_file.get_input_stream.read)
        xpath = "//b[contains(text(), 'SNOMED-CT:')]/i/span[@onmouseover and contains(text(), '417005')]"
        assert_equal 0, doc.xpath(xpath).length
      end
    end
    File.delete(zip_path)
  end

  test "excel export sheet names" do
    measure_hqmf_set_id = "AD9F4340-93FE-406E-BB86-2AE6A1CA3422"
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'patient_details.json'))

    pop_details = [
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_10_char.json')),
        pop: "1 - Population"
      },
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_29_char.json')),
        pop: "Population 1"
      },
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_30_char.json')),
        pop: "Population 1"
      },
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_31_char.json')),
        pop: "Population 1"
      },
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_32_char.json')),
        pop: "Population 1"
      }
    ]

    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'statement_details.json'))

    # Tests using different lengths of population titles.
    pop_details.each do |population_details|
      get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details[:fixture], statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id
      assert_response :success
      assert_equal 'application/xlsx', response.header['Content-Type']
      assert_equal 'binary', response.header['Content-Transfer-Encoding']
      temp = Tempfile.new(["test", ".xlsx"])
      temp.write(response.body)
      temp.rewind()
      doc = Roo::Spreadsheet.open(temp.path)
      sheet1 = doc.sheet(population_details[:pop])
      
      assert !sheet1.nil?
      
      temp.close()
      temp.unlink()
    end
  end
  
  test "Excel export composite measure" do
    measure_hqmf_set_id = "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'composite_excel', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'composite_excel', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'composite_excel', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'composite_excel', 'statement_details.json'))

    get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)

    sheet = doc.sheet("1 - Population Criteria Section")
    if sheet.row(3)[9] == "doe"
      jon_doe_row = sheet.row(3)
      jane_smith_row = sheet.row(4)
    else
      jon_doe_row = sheet.row(4)
      jane_smith_row = sheet.row(3)
    end

    assert_equal "\nKEY\n", doc.sheet("KEY").row(1)[0]
    expected_rows = JSON.parse(File.read(File.join(Rails.root, "test", "fixtures", "expected_excel_results","CMS321v0_shared_patients_composite.json")))
    # There was a change in how Roo parses "FALSE", but it does not affect the actual excel export.
    jon_doe_row[12] = "FALSE" if jon_doe_row[12] == false
    jane_smith_row[12] = "FALSE" if jane_smith_row[12] == false

    assert_equal expected_rows["jon_doe_row"], jon_doe_row
    assert_equal expected_rows["jane_smith_row"], jane_smith_row

    temp.close()
    temp.unlink()
  end

  test "Excel export fields check" do
    measure_hqmf_set_id = "442F4F7E-3C22-4641-9BEE-0E968CC38EF2"
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'statement_details.json'))

    get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)

    key_sheet = doc.sheet("KEY")
    assert_equal "\nKEY\n", key_sheet.row(1)[0]
    assert_equal "Interval", key_sheet.row(7)[0]
    assert_equal "INTERVAL: start value - end value", key_sheet.row(7)[1]
    assert_equal "INTERVAL: 11/20/2010 - 11/20/2012 or INTERVAL: 1 - 4", key_sheet.row(7)[2]

    sheet1 = doc.sheet("1 - Population Criteria Section")

    row2 = sheet1.row(2)
    assert_equal "IPP", row2[0]
    assert_equal "DENOM", row2[1]
    assert_equal "notes", row2[8]
    assert_equal "last", row2[9]
    assert_equal "first", row2[10]

    row3 = sheet1.row(3)
    assert_equal 0.0, row3[0]
    assert_equal "test2", row3[8]
    assert_equal "last_a", row3[9]
    assert_equal "first_a", row3[10]
    assert_equal "02/02/2011", row3[11]
    # The actual export will show "TRUE", but roo now shows true
    row3[12] = "TRUE" if row3[12] == true
    assert_equal "TRUE", row3[12]
    assert_equal "10/05/2017", row3[13]
    assert_equal "Not Hispanic or Latino", row3[14]
    assert_equal "Asian", row3[15]
    assert_equal "M", row3[16]

    row4 = sheet1.row(4)
    assert_equal 0.0, row4[0]
    assert_equal "test1", row4[8]
    assert_equal "last_b", row4[9]
    assert_equal "first_b", row4[10]
    assert_equal "03/04/1971", row4[11]
    # The actual export will show "FALSE", but roo now shows false
    row4[12] = "FALSE" if row4[12] == false
    assert_equal "FALSE", row4[12]
    assert_nil row4[13]
    assert_equal "Not Hispanic or Latino", row4[14]
    assert_equal "American Indian or Alaska Native", row4[15]
    assert_equal "M", row4[16]
    
    temp.close()
    temp.unlink()
  end
  
  test "Excel export cv measures" do
    measure_hqmf_set_id = "28AC347D-2F91-4A0C-9395-2602134BAA89"
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'statement_details.json'))

    get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)
    sheet1 = doc.sheet("1 - Population Criteria Section")

    row2 = sheet1.row(2)
    assert_equal "OBSERV", row2[2]
    assert_equal "OBSERV", row2[6]

    #Ensure that observe equal each other as they should
    row3 = sheet1.row(3)
    assert_equal "[115]", row3[2]
    assert_equal "[115]", row3[6]
    
    #Ensure that observ [nil] equals observ [nil] properly
    s1_r4 = sheet1.row(4)
    assert_equal "[nil]", s1_r4[2]
    assert_equal "[nil]", s1_r4[6]
    
    #Ensure that patients whose expected observ is nil evaluate correctly when value is []
    sheet3 = doc.sheet("3 - Stratification 2")
    s3_r4 = sheet3.row(4)
    assert_equal "[]", s3_r4[3]
    assert_equal "[]", s3_r4[8]
    
    temp.close()
    temp.unlink()
  end

  test "Excel export no results tests" do
    measure_hqmf_set_id = "28AC347D-2F91-4A0C-9395-2602134BAA89"
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'statement_details.json'))
    calc_results = {}.to_json
    get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id
  
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)

    # Check we only get the error sheet and that it is as expected
    assert_equal 1, doc.sheets.length
    assert_equal "Error", doc.sheets[0]
    assert_equal "Measure has no patients, please re-export with patients", doc.sheet(0).row(1)[0]

    temp.close()
    temp.unlink()
  end
  
end
