require 'test_helper'

class PopulationsControllerTest  < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    cql_measures_set = File.join("cql_measures")
    collection_fixtures(cql_measures_set, users_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, CqlMeasure.all)
    sign_in @user
  end

  test "update population" do
    sign_in @user
    # This particular test measure has multiple populations, and therefore can have their titles changed
    measure = CqlMeasure.by_user(@user).where(hqmf_set_id: "A4B9763C-847E-4E02-BB7E-ACC596E90E2C").first
    assert_equal("Population Criteria Section 1",measure.populations[0]['title'])
    # Change title of Population1 from "85 days" to "New Title Text"
    post :update, {measure_id: measure.id.to_s,
      id: "PopulationCriteria1", title: "New Title Text"}
    measure = CqlMeasure.by_user(@user).where(hqmf_set_id: "A4B9763C-847E-4E02-BB7E-ACC596E90E2C").first
    assert_equal("New Title Text",measure.populations[0]['title'])
  end

end
