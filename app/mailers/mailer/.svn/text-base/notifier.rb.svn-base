class Mailer::Notifier < ActionMailer::Base
  default :from => "#{configatron.from_email}"
  
  def send_password_to_user(user,password)
  	@user  = user
  	@password = password
   mail(:to => "#{user.email}", :subject => "Your account details for Securecopper")
  end
  
end
