FactoryBot.define do
  factory :time_period do
    name { Faker::Music.genre }
    description { Faker::Lorem.paragraph }
    start_year { Faker::Number.between(from: 1900, to: 1950) }
    end_year { Faker::Number.between(from: 1951, to: 2000) }
    slug { Faker::Internet.slug(words: name, glue: "-") }
    association :orchestra

    after(:build) do |time_period|
      time_period.image.attach(io: File.open(Rails.root.join("spec/support/assets/time_period.png")), filename: "time_period.png", content_type: "image/png")
    end
  end
end
