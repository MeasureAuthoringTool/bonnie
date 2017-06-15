require 'test_helper'

class PopulationsControllerTest  < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(measures_set, users_set)
    @user = User.by_email('bonnie@example.com').first

    associate_user_with_measures(@user,Measure.all)
    @user.measures.first.value_set_oids.uniq.each_with_index do |oid|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
      (0..10).each do |index|
        vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:"bar_#{index}")
      end
      vs.user = @user
      vs.save!
    end
    sign_in @user
  end

  test "get population javascript" do
    measure = Measure.all.first
    measure.map_fns = []
    measure.save!
    get :calculate_code, {measure_id: measure.id, id: 0, format: :js}
    assert_response :success
    assert_operator response.body.length, :>, 100
    assert response.body.starts_with? "(function()"
  end

  test "update population" do
    sign_in @user
    # This particular test measure has multiple populations, and therefore can have their titles changed
    measure = Measure.by_user(@user).find("53ce63744d4d32e2cd4b0502")
    assert_equal("85 days",measure.populations.at("Populations1".to_i)['title'])
    # Change title of Population1 from "85 days" to "New Title Text"
    post :update, {measure_id: "53ce63744d4d32e2cd4b0502",
      id: "Populations1", title: "New Title Text"}
    measure = Measure.by_user(@user).find("53ce63744d4d32e2cd4b0502")
    assert_equal("New Title Text",measure.populations.at("Populations1".to_i)['title'])
  end

end
