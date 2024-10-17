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
#  id              :integer          not null, primary key
#  email           :text             not null
#  username        :text
#  password_digest :string           not null
#  provider        :string
#  uid             :string
#  admin           :boolean          default(FALSE), not null
#  approved_at     :datetime
#  confirmed_at    :datetime
#  verified        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
