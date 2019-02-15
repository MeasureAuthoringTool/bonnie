require 'test_helper'

class PopulationsControllerTest  < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    load_measure_fixtures_from_folder(File.join("measures", "CMS160v6"), @user)
    sign_in @user
  end

  test "update population" do
    sign_in @user
    # This particular test measure has multiple populations, and therefore can have their titles changed
    measure = CQM::Measure.by_user(@user).where(hqmf_set_id: "A4B9763C-847E-4E02-BB7E-ACC596E90E2C").first
    assert_equal("Population Criteria Section", measure.population_sets[0].title)
    post :update, {measure_id: measure.id.to_s,
                   id: "PopulationCriteria1", title: "New Title Text"}
    measure = CQM::Measure.by_user(@user).where(hqmf_set_id: "A4B9763C-847E-4E02-BB7E-ACC596E90E2C").first
    assert_equal("New Title Text",measure.population_sets[0].title)
  end

end
