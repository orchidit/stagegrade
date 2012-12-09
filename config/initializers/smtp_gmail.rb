ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true,
  :domain => "stagegrade.com",
  :user_name => "noreply@stagegrade.com",
  :password => "stagegrade11noreply"
}