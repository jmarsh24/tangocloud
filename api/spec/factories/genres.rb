FactoryBot.define do
  factory :genre do
    name { Faker::Music.genre }
    description { Faker::Lorem.sentence }
  end
end
