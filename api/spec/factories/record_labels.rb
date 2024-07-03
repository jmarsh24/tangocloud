FactoryBot.define do
  factory :record_label do
    name { Faker::Music.band }
    description { Faker::Lorem.paragraph }
    founded_date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
  end
end
