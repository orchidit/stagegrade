class SignupMailer < ActionMailer::Base
  default_url_options[:host] = RAILS_ENV == "production" ? "www.stagegrade.com" : "dev.stagegrade.com"
  def common_setup
    from          "StageGrade <noreply@stagegrade.com>"
    content_type  "multipart/alternative"
  end

  def email_list_signup_notification(email)
    common_setup
    recipients  email.address
    subject     "Welcome to the StageGrade Newsletter!"
    body        :email => email
  end

  def account_signup_notification(user)
    recipients  user.email
    subject     "Spread the word on StageGrade!"
    body        :user => user
  end
end
