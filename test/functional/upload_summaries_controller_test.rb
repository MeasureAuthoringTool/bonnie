require 'test_helper'

class UploadSummariesControllerTest  < ActionController::TestCase
include Devise::Test::ControllerHelpers

  setup do
    @error_dir = File.join('log','load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(measures_set, users_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    sign_in @user
  end
  
  test "index of measure with no upload summaries" do
    get :index, { measure_id: @measure.id, format: :json }
    assert_response :success
    assert_equal [], JSON.parse(response.body)
  end
  
  test "index on non-existent measure" do
    get :index, { measure_id: "1234567890abcdef01234567", format: :json }
    assert_response :not_found
  end
end
