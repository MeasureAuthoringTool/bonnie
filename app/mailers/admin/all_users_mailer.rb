class Admin::AllUsersMailer < ActionMailer::Base

  def all_users_email(user, subject, body)
    @subject = subject
    @body = body
    mail to: user.email,
      subject: subject,
      from: 'bonnie-feedback-list@lists.mitre.org'
  end

end
