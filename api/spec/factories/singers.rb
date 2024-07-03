FactoryBot.define do
  factory :singer do
    name { Faker::Name.name }
    slug { Faker::Internet.slug(words: name, glue: "-") }
    rank { Faker::Number.between(from: 0, to: 100) }
    soloist { [true, false].sample }
    bio { Faker::Lorem.paragraph }
    birth_date { Faker::Date.between(from: "1900-01-01", to: "2000-12-31") }
    death_date { Faker::Date.between(from: "2000-01-01", to: "2020-12-31") }

    after(:build) do |singer|
      singer.photo.attach(
        io: File.open(Rails.root.join("spec/support/assets/singer.png")),
        filename: "singer.png",
        content_type: "image/png"
      )
    end
  end
end
