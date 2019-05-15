require 'test_helper'

class PopulationsControllerTest  < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    load_measure_fixtures_from_folder(File.join('measures', 'CMS32v7'), @user)
    sign_in @user
  end

  test 'update population' do
    sign_in @user
    # This particular test measure has multiple stratifications, and therefore can have their titles changed
    measure = CQM::Measure.by_user(@user).where(hqmf_set_id: '3FD13096-2C8F-40B5-9297-B714E8DE9133').first
    assert_equal('Population Criteria Section', measure.population_sets[0].title)
    post :update, {measure_id: measure.id.to_s,
                   id: 'PopulationCriteria1', title: 'ps1'}
    post :update, {measure_id: measure.id.to_s,
                   id: 'PopulationCriteria1 - Stratification 2', title: 'ps1strat2'}
    measure = CQM::Measure.by_user(@user).where(hqmf_set_id: '3FD13096-2C8F-40B5-9297-B714E8DE9133').first
    assert_equal('ps1', measure.population_sets[0].title)
    assert_equal('ps1strat2', measure.population_sets[0].stratifications[1].title)
  end

end
