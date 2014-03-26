class UserMailer < ActionMailer::Base

  def user_signup_email(user)
    @user = user
    @bonnie_host = case Rails.env
                   when 'staging' then 'bonnie.ahrqstg.org'
                   when 'production' then 'bonnie.healthit.gov'
                   else 'localhost:3000'
                   end
    mail to: 'bonnie-feedback-list@lists.mitre.org', subject: '[Bonnie] New user signup', from: "bonnie@#{@bonnie_host}"
  end

  def account_activation_email(user)
    @user = user
    mail to: @user.email, subject: 'Welcome to Bonnie', from: 'bonnie-feedback-list@lists.mitre.org'
  end

end
