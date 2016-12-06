require 'test_helper'

class ArchivedMeasuresControllerTest  < ActionController::TestCase
include Devise::TestHelpers

  setup do
    @error_dir = File.join('log','load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    draft_measures = File.join("draft_measures","base_set")
    archived_measures = File.join("archived_measures","base_set")
    users = File.join("users","base_set")
    collection_fixtures(draft_measures, users, archived_measures)
    @user = User.by_email('bonnie@example.com').first
    @measure = Measure.where({"cms_id" => "CMS128v2"}).first
    associate_user_with_measures(@user,[@measure])
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
  
  
  test "show archived measure" do
    measure_with_archive = Measure.where({"cms_id" => "CMS104v2"}).first
    archived_measure = ArchivedMeasure.first
    associate_archived_measures_with_measure([archived_measure],measure_with_archive)
    associate_user_with_measures(@user,[measure_with_archive,archived_measure])
    get :show, {measure_id: measure_with_archive.id, id: archived_measure.id, format: :json}
    assert_response :success
  end
  
end
