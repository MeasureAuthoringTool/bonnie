require 'test_helper'
require 'vcr_setup.rb'

class VsacUtilControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    sign_in @user
  end

  test 'get profile_names' do
    VCR.use_cassette('vsac_util_get_profile_names') do
      get :profile_names
      assert_response :success

      profile_names = JSON.parse(response.body)
      assert_equal 18, profile_names['profileNames'].length
      assert_equal 'eCQM Update 2018-05-04', profile_names['latestProfile']
    end
  end

  test 'get program_names' do
    VCR.use_cassette('vsac_util_get_program_names') do
      get :program_names
      assert_response :success
      assert_equal ['CMS Hybrid', 'CMS eCQM', 'HL7 C-CDA'], JSON.parse(response.body)['programNames']
    end
  end

  test 'get program_release_names' do
    VCR.use_cassette('vsac_util_get_program_release_names') do
      get :program_release_names, program: 'CMS eCQM'
      assert_response :success

      release_names = JSON.parse(response.body)
      assert_equal 'CMS eCQM', release_names['programName']
      assert_equal 14, release_names['releaseNames'].length
    end
  end

  test 'get program_release_names invalid program' do
    VCR.use_cassette('vsac_util_get_program_release_names_invalid_program') do
      get :program_release_names, program: 'Bad Program'
      assert_response :not_found
      assert_equal 'Program not found.', JSON.parse(response.body)['error']
    end
  end

  test "vsac auth valid" do
    # The ticket field was taken from the vcr_cassettes/valid_vsac_response file
    session[:vsac_tgt] = {ticket: "ST-67360-HgEfelIvwUQ3zz3X39fg-cas", expires: Time.now + 27000}
    get :auth_valid

    assert_response :ok
    assert_equal true, JSON.parse(response.body)['valid']
  end

  test "vsac auth invalid" do
    # Time is past expired
    # The ticket field was taken from the vcr_cassettes/valid_vsac_response file
    session[:vsac_tgt] = {ticket: "ST-67360-HgEfelIvwUQ3zz3X39fg-cas", expires: Time.now - 27000}
    get :auth_valid

    assert_response :ok
    assert_equal false, JSON.parse(response.body)['valid']
  end

  test "force expire vsac session" do
    # The ticket field was taken from the vcr_cassettes/valid_vsac_response file
    session[:vsac_tgt] = {ticket: "ST-67360-HgEfelIvwUQ3zz3X39fg-cas", expires: Time.now + 27000}
    post :auth_expire

    assert_response :ok
    assert_equal "{}", response.body

    assert_nil session[:vsac_tgt]

    # Assert that vsac_auth_valid returns that vsac session is invalid
    get :auth_valid

    assert_response :ok
    assert_equal false, JSON.parse(response.body)['valid']
  end
end
