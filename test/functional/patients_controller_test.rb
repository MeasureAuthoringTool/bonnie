require 'test_helper'

class PatientsControllerTest  < ActionController::TestCase
include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    cql_measures_set = File.join("cql_measures", "**")
    collection_fixtures(cql_measures_set, users_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, CqlMeasure.all)
    @measure = CqlMeasure.where({"cms_id" => "CMS134v6"}).first
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
    records_set = File.join("records", "core_records", "CMS134v6")
    collection_fixtures(records_set)
    associate_user_with_patients(@user, Record.all)
    associate_measures_with_patients([@measure], Record.all)

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
      assert_equal 2, zip_file.glob(File.join('qrda','**.xml')).length
      html_files = zip_file.glob(File.join('html', '**.html'))
      assert_equal 2, html_files.length
      html_files.each do |html_file| # search each HTML file to ensure alternate measure data is not included
        doc = Nokogiri::HTML(html_file.get_input_stream.read)
        xpath = "//b[contains(text(), 'SNOMED-CT:')]/i/span[@onmouseover and contains(text(), '417005')]"
        assert_equal 0, doc.xpath(xpath).length
      end
    end
    File.delete(zip_path)
  end

  test "excel export sheet names" do
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
      get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details[:fixture], statement_details: statement_details, file_name: "test"
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
  
  test "Excel export fields check" do
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'statement_details.json'))

    get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test"
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)
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
    assert_equal "FALSE", row4[12]
    assert_nil row4[13]
    assert_equal "Not Hispanic or Latino", row4[14]
    assert_equal "American Indian or Alaska Native", row4[15]
    assert_equal "M", row4[16]
    
    temp.close()
    temp.unlink()
  end
  
  test "Excel export cv measures" do
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'statement_details.json'))

    get :excel_export, calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test"
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
    assert_equal nil, s3_r4[3]
    assert_equal nil, s3_r4[8]
    
    temp.close()
    temp.unlink()
  end
  
end
