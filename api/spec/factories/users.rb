FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password_digest { BCrypt::Password.create("password") }
    verified { false }
    provider { "email" }
    uid { SecureRandom.uuid }
    username { Faker::Internet.username }
    admin { false }

    after(:build) do |user|
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

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string
#  verified        :boolean          default(FALSE), not null
#  provider        :string
#  uid             :string
#  username        :string
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
