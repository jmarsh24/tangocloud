user = User.find_by(email: 'jmarsh24@gmail.com').becomes(User)
ActionAuth::UserMailer.with(user:).email_verification.deliver_now
