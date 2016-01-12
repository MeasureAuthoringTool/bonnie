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
    assert_equal "User #{@user_plain.email} requesting resource requiring admin access", not_authorized.message
  end

  test "get index json" do
    sign_in @user_admin
    get :index, {format: :json}
    assert_response :success
    assert_equal 4, JSON.parse(response.body).count
  end

  test "approve user" do
    sign_in @user_admin
    assert_equal false, @user_unapproved.approved?
    post :approve, {id: @user_unapproved.id, format: :json}
    assert_response :success
    @user_unapproved.reload
    assert_equal true, @user_unapproved.approved?

    mail = ActionMailer::Base.deliveries.last
    assert_equal @user_unapproved.email, mail.to.first
    assert_equal "bonnie-feedback-list@lists.mitre.org", mail.from.first
    assert_equal "Welcome to Bonnie", mail.subject
  end

  test "disable user" do
    sign_in @user_admin
    assert_equal true, @user_plain.approved?
    post :disable, {id: @user_plain.id, format: :json}
    assert_response :success
    @user_plain.reload
    assert_equal false, @user_plain.approved?
  end

  test "delete user" do
    sign_in @user_admin
    assert_equal 4, User.all.count
    assert_equal 1, User.where({id: @user_plain.id}).count
    delete :destroy, {id: @user_plain.id, format: :json}
    assert_response :success
    assert_equal 3, User.all.count
    assert_equal 0, User.where({id: @user_plain.id}).count
  end

  test "update user" do
    sign_in @user_admin

    assert_equal "user_plain@example.com", @user_plain.email
    assert_equal false, @user_plain.is_admin?
    assert_equal false, @user_plain.is_portfolio?
    put :update, {id: @user_plain.id, email: 'plain2@example.com', admin: true, portfolio: false, format: :json}
    assert_response :success

    @user_plain.reload
    assert_equal "plain2@example.com", @user_plain.email
    assert_equal true, @user_plain.is_admin?
    assert_equal false, @user_plain.is_portfolio?

    put :update, {id: @user_plain.id, email: 'plain2@example.com', admin: false, portfolio: true, format: :json}
    assert_response :success

    @user_plain.reload
    assert_equal "plain2@example.com", @user_plain.email
    assert_equal false, @user_plain.is_admin?
    assert_equal true, @user_plain.is_portfolio?

  end

  test "patients download" do
    sign_in @user_admin
    get :patients, {id: @user.id}
    assert_response :success
    assert_equal 4, JSON.parse(response.body).length
  end

  test "measures download" do
    sign_in @user_admin
    get :measures, {id: @user.id}
    assert_response :success
    assert_equal 3, JSON.parse(response.body).length
  end

  test "bundle download" do
    sign_in @user_admin
    get :bundle, {id: @user.id}
    assert_response :success
    assert_equal 'application/zip', response.header['Content-Type']
    assert_equal "attachment; filename=\"bundle_#{@user.email}_export.zip\"", response.header['Content-Disposition']
    assert_equal 'fileDownload=true; path=/', response.header['Set-Cookie']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']

    zip_path = File.join('tmp','test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      assert_equal 4, zip_file.glob(File.join('patients','**','*.json')).count
      assert_equal 3, zip_file.glob(File.join('sources','**','*.json')).count
      assert_equal 3, zip_file.glob(File.join('sources','**','*.metadata')).count
      assert_equal 27, zip_file.glob(File.join('value_sets','**','*.json')).count
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
