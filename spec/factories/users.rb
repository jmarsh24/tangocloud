FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:username) { |n| "#{Faker::Name.first_name}_#{n}" }
    password { Faker::Internet.password }
    admin { false }

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
#  username        :string
#  provider        :string
#  uid             :string
#  admin           :boolean          default(FALSE), not null
#  approved_at     :datetime
#  verified        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
