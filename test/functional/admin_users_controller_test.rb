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

    associate_user_with_measures(@user, Measure.all)
    associate_user_with_patients(@user, Record.all)

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
    # Verify transmission of new user email
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
    # Verify bundle download contains correct amount of files
    zip_path = File.join('tmp', 'test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      assert_equal 4, zip_file.glob(File.join('patients', '**', '*.json')).count
      assert_equal 3, zip_file.glob(File.join('sources', '**', '*.json')).count
      assert_equal 3, zip_file.glob(File.join('sources', '**', '*.metadata')).count
      assert_equal 27, zip_file.glob(File.join('value_sets', '**', '*.json')).count
    end
    File.delete(zip_path)
  end

  test "sign in as" do
     sign_in @user_admin
     pre_count = @user_plain.sign_in_count
     post :log_in_as, {id: @user_plain.id}
     assert_response :redirect
     @user_plain.reload
     assert_equal pre_count + 1, @user_plain.sign_in_count
  end

  test "email all" do
    ActionMailer::Base.deliveries = [] # reset the list of email deliveries to ensure clean slate
    mail = ActionMailer::Base.deliveries
    sign_in @user
    assert_not @user.admin?
    not_authorized = assert_raises RuntimeError do
      post :email_all, {subject: "Test Email All Subject", body: "email all body", format: :json}
    end
    assert_equal "User #{@user.email} requesting resource requiring admin access", not_authorized.message
    assert mail.empty?
    sign_out @user

    sign_in @user_admin
    assert @user_admin.admin?
    post :email_all, {subject: "Test Email All Subject", body: "email all body", format: :json}
    users_sent_emails = 0
    User.each do |user|
      if mail.any? {|email|  email.to.first == user.email}
        users_sent_emails += 1
      end
    end
    assert_equal users_sent_emails, User.count()
  end

  test "email active" do
    # Make sure each user's last sign in is greater than 6 months
    User.each do |user|
      user.last_sign_in_at = Date.today - 8.months
      user.save!
    end
    ActionMailer::Base.deliveries = [] # reset the list of email deliveries to ensure clean slate
    mail = ActionMailer::Base.deliveries
    sign_in @user
    assert_not @user.admin?
    not_authorized = assert_raises RuntimeError do
      post :email_active, {subject: "Example Subject for Testing", body: "test body of email", format: :json}
    end
    assert_equal "User #{@user.email} requesting resource requiring admin access", not_authorized.message
    assert mail.empty?
    sign_out @user

    sign_in @user_admin
    assert @user_admin.admin?
    # The following tests greater than 6 months, and 0 measures
    @user_admin.last_sign_in_at = Date.today - 8.months
    @user_admin.measure_count = 0
    @user_admin.save! # update the database with the test values
    post :email_active, {subject: "Example Subject for Testing", body: "test body of email", format: :json}
    assert mail.empty?
    # The following tests fewer than 6 months, but 0 measures
    @user_admin.last_sign_in_at = Date.today - 1.months
    @user_admin.save!
    post :email_active, {subject: "Example Subject for Testing", body: "test body of email", format: :json}
    assert mail.empty?
    # The following tests greater than 6 months, but 3 measures
    @user_admin.last_sign_in_at = Date.today - 8.months # arbitrary date more than 6 months ago
    associate_user_with_measures(@user_admin, Measure.all)
    @user_admin.save!
    post :email_active, {subject: "Example Subject for Testing", body: "test body of email", format: :json}
    assert mail.empty?
    # The following tests fewer than 6 months, and 3 measures, so we should recieve an  email
    @user_admin.last_sign_in_at = Date.today - 1.months
    @user_admin.save!
    post :email_active, {subject: "Email Sent!", body: "test body of email", format: :json}
    assert_equal 1, mail.last.to.length # ensure that only one email was sent
    assert_equal "Email Sent!", mail.last.subject # This test should pass because the user has more than 0 measures, and is younger than 6 months
    assert_equal @user_admin.email, mail.last.to.first
  end
end
