class UserMailer < ActionMailer::Base

  def user_signup_email(user)
    @user = user
    @bonnie_host = APP_CONFIG['hostname']
    mail to: 'bonnie-feedback-list@lists.mitre.org', subject: '[Bonnie] New user signup', from: "bonnie@#{@bonnie_host}"
  end

  def account_activation_email(user)
    @user = user
    mail to: @user.email, subject: 'Welcome to Bonnie', from: 'bonnie-feedback-list@lists.mitre.org'
  end

end
