require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    dump_database
    collection_fixtures("draft_measures", "users")
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    @user_unapproved = User.by_email('user_unapproved@example.com').first
  end
  test "index" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "index fails unapproved" do
    sign_in @user_unapproved
    get :index
    assert_response :redirect
    flash[:alert].must_equal "Your account is not activated yet."
  end
end
