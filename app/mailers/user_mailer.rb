class UserMailer < ActionMailer::Base

  def user_signup_email(user)
    @user = user
    @bonnie_host = APP_CONFIG['hostname']
    mail to: APP_CONFIG['bonnie_email'], subject: '[Bonnie] New user signup', from: APP_CONFIG['bonnie_from_email']
  end

  def account_activation_email(user)
    @user = user
    mail to: @user.email, subject: 'Welcome to Bonnie', from: APP_CONFIG['bonnie_from_email']
  end

end
