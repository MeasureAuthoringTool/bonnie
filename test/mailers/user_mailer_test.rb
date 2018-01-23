require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = User.new(email: 'email_test@test.com', first: "first" , last: 'last', password: 'Test1234!')
  end

  test 'user signup email' do
    email = UserMailer.user_signup_email(@user).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal '[Bonnie] New user signup', email.subject
    # User signed up email is sent to our "non hard coded" address
    assert_equal [APP_CONFIG['bonnie_email']], email.to
  end

  test 'account activation email' do
    email = UserMailer.account_activation_email(@user).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [@user.email], email.to
    assert_equal 'Welcome to Bonnie', email.subject
    # Activation email is sent from our "non hard coded" address
    assert_equal [APP_CONFIG['bonnie_email']], email.from
  end
end