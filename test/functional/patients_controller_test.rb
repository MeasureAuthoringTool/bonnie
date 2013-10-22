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

  test "save" do
    @patient = {'first'=> 'Betty', 
     'last'=> 'Boop', 
     'gender'=> 'F', 
     'expired'=> 'true' ,
     'birthdate'=> "1930-10-17", 
     'ethnicity'=> 'B', 
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'data_criteria' => '[{"id":"EncounterPerformedPsychVisitDiagnosticEvaluation","start_date":1333206000000,"end_date":1333206000000,"value":[],"negation":"","negation_code_list_id":null,"field_values":{},"oid":"2.16.840.1.113883.3.526.3.1492"}]',
    'id' => @measure.id}

    post :save, @patient
  end

  test "materialize" do
    post :materialize,{'first'=> 'Betty', 
     'last'=> 'Boop', 
     'gender'=> 'F', 
     'expired'=> 'true' ,
     'birthdate'=> "1930-10-17", 
     'ethnicity'=> 'B', 
     'race'=> 'B',
     'start_date'=>'2012-01-01',
     'end_date'=>'2012-12-31',
     'data_criteria' => '[{"id":"EncounterPerformedPsychVisitDiagnosticEvaluation","start_date":1333206000000,"end_date":1333206000000,"value":[],"negation":"","negation_code_list_id":null,"field_values":{},"oid":"2.16.840.1.113883.3.526.3.1492"}]',
     'id' => @measure.id}
  end


end