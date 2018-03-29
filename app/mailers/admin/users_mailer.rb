class Admin::UsersMailer < ActionMailer::Base

  def users_email(user, subject, body)
    @subject = subject
    @body = body
    mail to: user.email,
      subject: subject,
      from: APP_CONFIG['bonnie_email']
  end

end
