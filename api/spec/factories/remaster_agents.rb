FactoryBot.define do
  factory :remaster_agent do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    url { Faker::Internet.url }
  end
end
