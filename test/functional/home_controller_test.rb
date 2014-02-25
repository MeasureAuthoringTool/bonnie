require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    dump_database
    collection_fixtures("draft_measures", "users")
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    sign_in @user
  end
  test "index" do
    get :index
    assert_response :success
  end
end
