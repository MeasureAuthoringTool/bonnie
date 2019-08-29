require 'test_helper'

class Admin::UsersControllerTest  < ActionController::TestCase
include Devise::Test::ControllerHelpers

  setup do
    dump_database
    patients_set = File.join('cqm_patients', 'CMS903v0')
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set, patients_set)
    @user = User.by_email('bonnie@example.com').first
    @user_admin = User.by_email('user_admin@example.com').first
    @user_plain = User.by_email('user_plain@example.com').first
    @user_unapproved = User.by_email('user_unapproved@example.com').first

    load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @user)
    associate_user_with_patients(@user, CQM::Patient.all)

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
    get :index, params: {format: :json}
    assert_response :success
    index_json = JSON.parse(response.body)
    assert_equal 4, index_json.count
    assert_equal 1, index_json[0]['measure_count']
    assert_equal 4, index_json[0]['patient_count']
    assert_equal 0, index_json[1]['measure_count']
    assert_equal 0, index_json[1]['patient_count']
    assert_equal 0, index_json[2]['measure_count']
    assert_equal 0, index_json[2]['patient_count']
    assert_equal 0, index_json[3]['measure_count']
    assert_equal 0, index_json[3]['patient_count']
  end

  test "approve user" do
    sign_in @user_admin
    assert_equal false, @user_unapproved.approved?
    post :approve, params: {id: @user_unapproved.id, format: :json}
    assert_response :success
    @user_unapproved.reload
    assert_equal true, @user_unapproved.approved?
    # Verify transmission of new user email
    mail = ActionMailer::Base.deliveries.last
    assert_equal @user_unapproved.email, mail.to.first
    assert_equal APP_CONFIG['bonnie_email'], mail.from.first
    assert_equal "Welcome to Bonnie", mail.subject
  end

  test "disable user" do
    sign_in @user_admin
    assert_equal true, @user_plain.approved?
    post :disable, params: {id: @user_plain.id, format: :json}
    assert_response :success
    @user_plain.reload
    assert_equal false, @user_plain.approved?
  end

  test "delete user" do
    sign_in @user_admin
    assert_equal 4, User.all.count
    assert_equal 1, User.where({id: @user_plain.id}).count
    delete :destroy, params: {id: @user_plain.id, format: :json}
    assert_response :success
    assert_equal 3, User.all.count
    assert_equal 0, User.where({id: @user_plain.id}).count
  end

  test "update user" do
    sign_in @user_admin

    assert_equal "user_plain@example.com", @user_plain.email
    assert_equal false, @user_plain.is_admin?
    assert_equal false, @user_plain.is_portfolio?
    put :update, params: {id: @user_plain.id, email: 'plain2@example.com', admin: true, portfolio: false, format: :json}
    assert_response :success

    @user_plain.reload
    assert_equal "plain2@example.com", @user_plain.email
    assert_equal true, @user_plain.is_admin?
    assert_equal false, @user_plain.is_portfolio?

    put :update, params: {id: @user_plain.id, email: 'plain2@example.com', admin: false, portfolio: true, format: :json}
    assert_response :success

    @user_plain.reload
    assert_equal "plain2@example.com", @user_plain.email
    assert_equal false, @user_plain.is_admin?
    assert_equal true, @user_plain.is_portfolio?

  end

  test "patients download" do
    sign_in @user_admin
    get :patients, params: {id: @user.id}
    assert_response :success
    assert_equal 4, JSON.parse(response.body).length
  end

  test "measures download" do
    sign_in @user_admin
    get :measures, params: {id: @user.id}
    assert_response :success
    assert_equal 1, JSON.parse(response.body).length
  end

  test "sign in as" do
     sign_in @user_admin
     pre_count = @user_plain.sign_in_count
     post :log_in_as, params: {id: @user_plain.id}
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
      post :email_all, params: {subject: "Test Email All Subject", body: "email all body", format: :json}
    end
    assert_equal "User #{@user.email} requesting resource requiring admin access", not_authorized.message
    assert mail.empty?
    sign_out @user

    sign_in @user_admin
    assert @user_admin.admin?
    post :email_all, params: {subject: "Test Email All Subject", body: "email all body", format: :json}
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
      post :email_active, params: {subject: "Example Subject for Testing", body: "test body of email", format: :json}
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
    post :email_active, params: {subject: "Example Subject for Testing", body: "test body of email", format: :json}
    assert mail.empty?
    # The following tests fewer than 6 months, but 0 measures
    @user_admin.last_sign_in_at = Date.today - 1.months
    @user_admin.save!
    post :email_active, params: {subject: "Example Subject for Testing", body: "test body of email", format: :json}
    assert mail.empty?
    # The following tests greater than 6 months, but 0 measure
    @user_admin.last_sign_in_at = Date.today - 8.months # arbitrary date more than 6 months ago
    associate_user_with_measures(@user_admin, CQM::Measure.all)
    @user_admin.save!
    post :email_active, params: {subject: "Example Subject for Testing", body: "test body of email", format: :json}
    assert mail.empty?
    # The following tests fewer than 6 months, and 1 measures, so we should recieve an  email
    @user_admin.last_sign_in_at = Date.today - 1.months
    @user_admin.save!
    post :email_active, params: {subject: "Email Sent!", body: "test body of email", format: :json}
    assert_equal 1, mail.last.to.length # ensure that only one email was sent
    assert_equal "Email Sent!", mail.last.subject # This test should pass because the user has more than 0 measures, and is younger than 6 months
    assert_equal @user_admin.email, mail.last.to.first
  end
end
