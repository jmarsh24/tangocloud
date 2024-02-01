# frozen_string_literal: true

if !User.exists?(email: "admin@tangocloud.app")
  User.create!(
    email: "admin@tangocloud.app",
    password: "adminpassword",
    username: "admin",
    first_name: "Admin",
    last_name: "User",
    verified: true,
    admin: true
  )
end
