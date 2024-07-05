FactoryBot.define do
  factory :subscription do
    association :user
    name { Faker::Subscription.plan }
    description { Faker::Lorem.sentence }
    start_date { Faker::Date.backward(days: 14) }
    end_date { Faker::Date.forward(days: 365) }
    subscription_type { Subscription.subscription_types.keys.sample }
  end
end

# == Schema Information
#
# Table name: subscriptions
#
#  id                :uuid             not null, primary key
#  name              :string           not null
#  description       :string
#  start_date        :datetime         not null
#  end_date          :datetime         not null
#  subscription_type :enum             default("free"), not null
#  user_id           :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
