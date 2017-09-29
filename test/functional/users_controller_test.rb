require 'test_helper'

class UsersControllerTest  < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    dump_database
    records_set = File.join("records", "base_set")
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(users_set, records_set, measures_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, Measure.all)
    associate_user_with_patients(@user, Record.all)

    @user.measures.first.value_set_oids.uniq.each do |oid|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
      vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:'bar')
      vs.user = @user
      vs.save!
    end

  end

  test "bundle download" do
    # we need to show it currently is DISABLED:
    assert_raises(ActionController::RoutingError) do
      get '/users/bundle'
    end
=begin
    sign_in @user
    get :bundle
    assert_response :success
    assert_equal 'application/zip', response.header['Content-Type']
    assert_equal "attachment; filename=\"bundle_#{@user.email}_export.zip\"", response.header['Content-Disposition']
    assert_equal 'fileDownload=true; path=/', response.header['Set-Cookie']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']

    zip_path = File.join('tmp', 'test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      assert_equal 4, zip_file.glob(File.join('patients', '**', '*.json')).count
      assert_equal 3, zip_file.glob(File.join('sources', '**', '*.json')).count
      assert_equal 3, zip_file.glob(File.join('sources', '**', '*.metadata')).count
      assert_equal 27, zip_file.glob(File.join('value_sets', '**', '*.json')).count
    end
    File.delete(zip_path)
=end
  end

end
