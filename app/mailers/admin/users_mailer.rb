class Admin::UsersMailer < ActionMailer::Base

  def users_email(user, subject, body)
    @subject = subject
    @body = body
    mail to: user.email,
      subject: subject,
      from: 'bonnie-feedback-list@lists.mitre.org'
  end

end
