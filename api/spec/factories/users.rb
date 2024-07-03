FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create("password") }
    verified { false }
    provider { "email" }
    uid { SecureRandom.uuid }
    username { Faker::Internet.username }
    admin { false }

    after(:create) do |user|
      create(:user_preference, user:)
    end

    factory :verified_user do
      verified { true }
    end

    factory :admin_user do
      admin { true }
    end
  end
end
