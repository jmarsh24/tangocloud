FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:username) { |n| "#{Faker::Name.first_name}_#{n}" }
    password { Faker::Internet.password }

    trait :admin do
      role { :admin }
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
#  email           :citext           not null
#  username        :citext
#  password_digest :string           not null
#  provider        :string
#  uid             :string
#  approved_at     :datetime
#  confirmed_at    :datetime
#  verified        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  role            :integer          default("user"), not null
#
