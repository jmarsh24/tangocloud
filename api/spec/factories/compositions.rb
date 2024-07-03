FactoryBot.define do
  factory :composition do
    title { Faker::Music.album }
    association :lyricist, factory: :lyricist
    association :composer, factory: :composer
  end
end
