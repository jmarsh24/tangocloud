FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    slug { Faker::Internet.slug(words: name, glue: "-") }
    birth_date { Faker::Date.between(from: "1850-01-01", to: "1950-12-31") }
    death_date { Faker::Date.between(from: "1900-01-01", to: "2000-12-31") }

    after(:build) do |person|
      person.photo.attach(io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")), filename: "orchestra.jpg", content_type: "image/jpg")
    end

    trait :composer do
      after(:create) do |person|
        create(:composition_role, person:, role: "composer")
      end
    end

    trait :lyricist do
      after(:create) do |person|
        create(:composition_role, person:, role: "lyricist")
      end
    end

    trait :singer do
      after(:create) do |person|
        create(:orchestra_role, person:, role: create(:role, name: "singer"))
      end
    end
  end
end

# == Schema Information
#
# Table name: people
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
