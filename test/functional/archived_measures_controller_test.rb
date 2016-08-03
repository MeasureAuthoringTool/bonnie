require 'test_helper'

class ArchivedMeasuresControllerTest  < ActionController::TestCase
include Devise::TestHelpers

  setup do
    @error_dir = File.join('log','load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    collection_fixtures("draft_measures", "users")
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    sign_in @user
  end
  
  test "index of measure with no archived measures" do
    get :index, { measure_id: @measure.id, format: :json }
    assert_response :success
    assert_equal [], JSON.parse(response.body)
  end
  
  test "index on non-existent measure" do
    get :index, { measure_id: "1234567890abcdef01234567", format: :json }
    assert_response :not_found
  end
end
