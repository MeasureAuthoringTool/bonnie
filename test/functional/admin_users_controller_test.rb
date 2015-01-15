require 'test_helper'

class Admin::UsersControllerTest  < ActionController::TestCase
include Devise::TestHelpers

  setup do
    dump_database
    collection_fixtures("users", "records", "draft_measures")
    @user = User.by_email('bonnie@example.com').first
    @user_admin = User.by_email('user_admin@example.com').first
    @user_plain = User.by_email('user_plain@example.com').first
    @user_unapproved = User.by_email('user_unapproved@example.com').first

    associate_user_with_measures(@user,Measure.all)
    associate_user_with_patients(@user,Record.all)

    @user.measures.first.value_set_oids.uniq.each do |oid|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
      vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:'bar')
      vs.user = @user
      vs.save!
    end

  end


  test "approve not as admin" do
    sign_in @user_plain
    not_authorized = assert_raises(RuntimeError) do
      get :index, {format: :json}
    end
    not_authorized.message.must_equal "User #{@user_plain.email} requesting resource requiring admin access"
  end

  test "get index json" do
    sign_in @user_admin
    get :index, {format: :json}
    assert_response :success
    JSON.parse(response.body).count.must_equal 4
  end

  test "approve user" do
    sign_in @user_admin
    @user_unapproved.approved?.must_equal false
    post :approve, {id: @user_unapproved.id, format: :json}
    assert_response :success
    @user_unapproved.reload
    @user_unapproved.approved?.must_equal true

    mail = ActionMailer::Base.deliveries.last
    mail.to.first.must_equal @user_unapproved.email
    mail.from.first.must_equal "bonnie-feedback-list@lists.mitre.org"
    mail.subject.must_equal "Welcome to Bonnie"
  end

  test "disable user" do
    sign_in @user_admin
    @user_plain.approved?.must_equal true
    post :disable, {id: @user_plain.id, format: :json}
    assert_response :success
    @user_plain.reload
    @user_plain.approved?.must_equal false
  end

  test "delete user" do
    sign_in @user_admin
    User.all.count.must_equal 4
    User.where({id: @user_plain.id}).count.must_equal 1
    delete :destroy, {id: @user_plain.id, format: :json}
    assert_response :success
    User.all.count.must_equal 3
    User.where({id: @user_plain.id}).count.must_equal 0
  end

  test "update user" do
    sign_in @user_admin

    @user_plain.email.must_equal "user_plain@example.com"
    @user_plain.is_admin?.must_equal false
    @user_plain.is_portfolio?.must_equal false
    put :update, {id: @user_plain.id, email: 'plain2@example.com', admin: true, portfolio: false, format: :json}
    assert_response :success

    @user_plain.reload
    @user_plain.email.must_equal "plain2@example.com"
    @user_plain.is_admin?.must_equal true
    @user_plain.is_portfolio?.must_equal false

    put :update, {id: @user_plain.id, email: 'plain2@example.com', admin: false, portfolio: true, format: :json}
    assert_response :success

    @user_plain.reload
    @user_plain.email.must_equal "plain2@example.com"
    @user_plain.is_admin?.must_equal false
    @user_plain.is_portfolio?.must_equal true

  end

  test "patients download" do
    sign_in @user_admin
    get :patients, {id: @user.id}
    assert_response :success
    JSON.parse(response.body).length.must_equal 4
  end

  test "measures download" do
    sign_in @user_admin
    get :measures, {id: @user.id}
    assert_response :success
    JSON.parse(response.body).length.must_equal 2
  end

  test "bundle download" do
    sign_in @user_admin
    get :bundle, {id: @user.id}
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

  # does not seem to allow sign in in testing
  # test "sign in as" do
  #   sign_in @user_admin
  #   put :log_in_as, {id: @user_plain.id}
  #   assert_response :redirect
  # end

end
