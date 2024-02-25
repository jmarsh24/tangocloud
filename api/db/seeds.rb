if !User.exists?(email: "admin@tangocloud.app")
  user = User.new(
    email: "admin@tangocloud.app",
    password: "tangocloud123",
    username: "admin",
    verified: true,
    admin: true
  )

  user.build_user_preference(
    first_name: "Admin",
    last_name: "User"
  )

  user.save!
end
