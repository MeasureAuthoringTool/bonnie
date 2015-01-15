require 'test_helper'

class UsersControllerTest  < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    dump_database
    collection_fixtures("users", "records", "draft_measures")
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    associate_user_with_patients(@user,Record.all)

    @user.measures.first.value_set_oids.uniq.each do |oid|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
      vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:'bar')
      vs.user = @user
      vs.save!
    end

  end

  test "bundle download" do
    sign_in @user
    get :bundle
    assert_response :success
    response.header['Content-Type'].must_equal 'application/zip'
    response.header['Content-Disposition'].must_equal "attachment; filename=\"bundle_#{@user.email}_export.zip\""
    response.header['Set-Cookie'].must_equal 'fileDownload=true; path=/'
    response.header['Content-Transfer-Encoding'].must_equal 'binary'

    zip_path = File.join('tmp','test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      zip_file.glob(File.join('patients','**','*.json')).count.must_equal 4
      zip_file.glob(File.join('sources','**','*.json')).count.must_equal 2
      zip_file.glob(File.join('sources','**','*.metadata')).count.must_equal 2
      zip_file.glob(File.join('value_sets','**','*.json')).count.must_equal 27
    end
    File.delete(zip_path)
  end

end
