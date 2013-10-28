require 'test_helper'

class PatientsControllerTest  < ActionController::TestCase
include Devise::TestHelpers
      
  setup do
    dump_database
    collection_fixtures("draft_measures", "users")
    @user = User.where({username: "bonnie"}).first
    associate_user_with_measures(@user,Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
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
     'source_data_criteria' => [{"id"=>"EncounterPerformedPsychVisitDiagnosticEvaluation","start_date"=>1333206000000,"end_date"=>1333206000000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"oid"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.measure_id}

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
     'source_data_criteria' => [{"id"=>"EncounterPerformedPsychVisitDiagnosticEvaluation","start_date"=>1333206000000,"end_date"=>1333206000000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"oid"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.measure_id}

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
     'source_data_criteria' => [{"id"=>"EncounterPerformedPsychVisitDiagnosticEvaluation","start_date"=>1333206000000,"end_date"=>1333206000000,"value"=>[],"negation"=>"","negation_code_list_id"=>nil,"field_values"=>{},"oid"=>"2.16.840.1.113883.3.526.3.1492"}],
     'measure_id' => @measure.measure_id}

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


end