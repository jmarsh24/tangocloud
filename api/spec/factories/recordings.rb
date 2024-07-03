FactoryBot.define do
  factory :recording do
    title { Faker::Music.album }
    recorded_date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
    recording_type { ["studio", "live"].sample }
    listens_count { Faker::Number.between(from: 0, to: 10000) }
    association :orchestra
    association :genre
    association :composition, factory: :composition
  end
end
