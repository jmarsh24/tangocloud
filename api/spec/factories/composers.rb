FactoryBot.define do
  factory :composer do
    name { Faker::Name.name }
    slug { Faker::Internet.slug(words: name, glue: "-") }
    birth_date { Faker::Date.between(from: "1850-01-01", to: "1950-12-31") }
    death_date { Faker::Date.between(from: "1900-01-01", to: "2000-12-31") }

    after(:build) do |composer|
      composer.photo.attach(io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")), filename: "orchestra.jpg", content_type: "image/jpg")
    end
  end
end
