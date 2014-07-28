require 'test_helper'

class PatientsControllerTest  < ActionController::TestCase
include Devise::TestHelpers
      
  setup do
    dump_database
    collection_fixtures("draft_measures", "users")
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    @measure_two = Measure.where({"cms_id" => "CMS104v2"}).first
    sign_in @user
  end

  test "create" do

    assert_equal 0,Record.count
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
    assert_equal 1,Record.count
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

    assert_equal 0,Record.count
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
    assert_equal 1,Record.count
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
   assert_equal 0,Record.count
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
    assert_equal 0,Record.count

    json = JSON.parse(response.body)

    assert_equal "Betty", json["first"]
    assert_equal "Boop", json["last"]
    assert_equal "F", json["gender"]
    assert_equal 2, json["source_data_criteria"].length
    assert_equal "EncounterPerformedPsychVisitDiagnosticEvaluation", json["source_data_criteria"][0]["id"]
    assert_equal 1, json["encounters"].length
  end

  test "destroy" do
    collection_fixtures("records")
    associate_user_with_patients(@user,Record.all)
    patient = Record.first
    @user.records.count.must_equal 4
    delete :destroy, {id: patient.id}
    assert_response :success
    @user.records.count.must_equal 3
    patient = Record.where({id: patient.id}).first
    patient.must_be_nil

  end

  test "export patients" do
    collection_fixtures("records")
    associate_user_with_patients(@user,Record.all)
    associate_measures_with_patients([@measure, @measure_two],Record.all)
    get :export, hqmf_set_id: @measure.hqmf_set_id
    assert_response :success
    response.header['Content-Type'].must_equal 'application/zip'
    response.header['Content-Disposition'].must_equal "attachment; filename=\"#{@measure.cms_id}_patient_export.zip\""
    response.header['Set-Cookie'].must_equal 'fileDownload=true; path=/'
    response.header['Content-Transfer-Encoding'].must_equal 'binary'

    zip_path = File.join('tmp','test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      zip_file.glob(File.join('qrda','**.xml')).length.must_equal 4
      html_files = zip_file.glob(File.join('html', '**.html'))
      html_files.length.must_equal 4
      html_files.each do |html_file| # search each HTML file to ensure alternate measure data is not included
        doc = Nokogiri::HTML(html_file.get_input_stream.read)
        xpath = "//b[contains(text(), 'SNOMED-CT:')]/i/span[@onmouseover and contains(text(), '417005')]"
        doc.xpath(xpath).length.must_equal 0
      end
    end
    File.delete(zip_path)
    
  end
    
  test "export patients portfolio" do
    collection_fixtures("records")
    associate_user_with_patients(@user,Record.all)
    associate_measures_with_patients([@measure, @measure_two],Record.all)
    @user.grant_portfolio()
    get :export, hqmf_set_id: @measure.hqmf_set_id
    assert_response :success
    response.header['Content-Type'].must_equal 'application/zip'
    response.header['Content-Disposition'].must_equal "attachment; filename=\"#{@measure.cms_id}_patient_export.zip\""
    response.header['Set-Cookie'].must_equal 'fileDownload=true; path=/'
    response.header['Content-Transfer-Encoding'].must_equal 'binary'

    zip_path = File.join('tmp','test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      zip_file.glob(File.join('qrda','**.xml')).length.must_equal 4
      html_files = zip_file.glob(File.join('html', '**.html'))
      html_files.length.must_equal 4
      html_files.each do |html_file| # search each HTML file to ensure alternate measure data is not included
        doc = Nokogiri::HTML(html_file.get_input_stream.read)
        xpath = "//b[contains(text(), 'SNOMED-CT:')]/i/span[@onmouseover and contains(text(), '417005')]"
        assert_operator doc.xpath(xpath).length, :>, 0
      end
    end
    File.delete(zip_path)

  end


end
