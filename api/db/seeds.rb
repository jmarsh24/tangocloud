# frozen_string_literal: true

if !ActionAuth::User.exists?(email: "admin@tangocloud.app")
  user = ActionAuth::User.create!(
    email: "admin@tangocloud.app",
    password: "adminpassword",
    verified: true
  )

  user.user_setting.update!(admin: true)
end
