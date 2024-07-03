FactoryBot.define do
  factory :lyric do
    locale { "en" }
    content { Faker::Lorem.paragraph }
    association :composition
  end
end
