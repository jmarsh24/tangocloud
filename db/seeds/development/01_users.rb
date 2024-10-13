def create_user(email:, password:, admin: false)
  user = User.find_or_create_by!(email:) do |u|
    u.password = password
    u.admin = admin
    u.verified = true
  end

  unless user.avatar.attached?
    user.avatar.attach(io: File.open(Rails.root.join("spec/fixtures/files/avatar.jpg")), filename: "avatar.jpg", content_type: "image/jpeg")
  end

  user
end

create_user(
  email: "admin@tangocloud.app",
  password: "tangocloud123",
  admin: true
)
create_user(email: "user@tangocloud.app", password: "tangocloud123")
