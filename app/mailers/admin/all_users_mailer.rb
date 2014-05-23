class Admin::AllUsersMailer < ActionMailer::Base

  def send_to_all(users, subject, body)
    @subject = subject
    @body = body
    mail to: "Bonnie Users",
      bcc: users.map { |user| user.email },
      subject: subject,
      from: 'bonnie-feedback-list@lists.mitre.org'
  end

end
