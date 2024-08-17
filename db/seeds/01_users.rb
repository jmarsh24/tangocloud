def create_user(email, password, admin = false)
  user = User.find_or_create_by!(email:) do |u|
    u.password = password
    u.admin = admin
    u.username = email.split("@").first
  end

  unless user.avatar.attached?
    user.avatar.attach(io: File.open(Rails.root.join("spec/fixtures/files/avatar.jpg")), filename: "avatar.jpg", content_type: "image/jpeg")
  end

  user
end

create_user("admin@tangocloud.app", "tangocloud123", true)
create_user("user@tangocloud.app", "tangocloud123")
