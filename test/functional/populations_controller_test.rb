require 'test_helper'

class PopulationsControllerTest  < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @user)
    sign_in @user
  end

  test 'update population' do
    sign_in @user
    # This particular test measure has multiple stratifications, and therefore can have their titles changed
    measure = CQM::Measure.by_user(@user).where(hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076').first
    assert_equal('Population Criteria Section', measure.population_sets[0].title)
    put :update, params: {measure_id: measure.id.to_s, id: '0',
                  population_set_id: 'PopulationSet_1', title: 'ps1'}
    put :update, params: {measure_id: measure.id.to_s, id: '0',
                  population_set_id: 'PopulationSet_1_Stratification_2', title: 'ps1strat2'}
    measure = CQM::Measure.by_user(@user).where(hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076').first
    assert_equal('ps1', measure.population_sets[0].title)
    assert_equal('ps1strat2', measure.population_sets[0].stratifications[1].title)
  end

end
