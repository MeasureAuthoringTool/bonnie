require 'test_helper'
require 'vcr_setup'

class VsacUtilControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    @user.init_personal_group
    @user.save
    sign_in @user
  end

  test 'get profile_names' do
    VCR.use_cassette('vsac_util_get_profile_names') do
      get :profile_names
      assert_response :success

      profile_names = JSON.parse(response.body)
      assert_equal 27, profile_names['profileNames'].length
      assert_equal 'eCQM Update 2020-05-07', profile_names['latestProfile']
    end
  end

  test 'get program_names' do
    VCR.use_cassette('vsac_util_get_program_names') do
      get :program_names
      assert_response :success
      assert_equal ["CMS Hybrid", "CMS Pre-rulemaking eCQM", "CMS eCQM", "HL7 C-CDA"], JSON.parse(response.body)['programNames']
    end
  end

  test 'get program_release_names' do
    VCR.use_cassette('vsac_util_get_program_release_names') do
      get :program_release_names, params: {program: 'CMS eCQM'}
      assert_response :success

      release_names = JSON.parse(response.body)
      assert_equal 'CMS eCQM', release_names['programName']
      assert_equal 16, release_names['releaseNames'].length
    end
  end

  test 'get program_release_names invalid program' do
    VCR.use_cassette('vsac_util_get_program_release_names_invalid_program') do
      get :program_release_names, params: {program: 'Bad Program'}
      assert_response :not_found
      assert_equal 'Program not found.', JSON.parse(response.body)['error']
    end
  end

  test "vsac auth valid" do
    # The ticket field was taken from the vcr_cassettes/valid_vsac_response file
    session[:vsac_api_key] = 'somethingDecent'
    get :auth_valid

    assert_response :ok
    assert_equal true, JSON.parse(response.body)['valid']
  end
end
