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
