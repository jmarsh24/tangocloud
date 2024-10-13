FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Faker::Internet.password }
    admin { false }

    after(:build) do |user|
      create(:user_preference, user:)
    end

    trait :admin do
      admin { true }
    end

    trait :approved do
      approved_at { Time.current }
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  provider        :string
#  uid             :string
#  admin           :boolean          default(FALSE), not null
#  verified        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved_at     :datetime
#
