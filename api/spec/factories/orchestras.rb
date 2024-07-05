FactoryBot.define do
  factory :orchestra do
    name { Faker::Music.band }
    rank { Faker::Number.between(from: 1, to: 100) }
    slug { Faker::Internet.slug(words: name, glue: "-") }
    sort_name { name.split.last }
    birth_date { Faker::Date.between(from: "1850-01-01", to: "1950-12-31") }
    death_date { Faker::Date.between(from: "1900-01-01", to: "2000-12-31") }

    after(:build) do |orchestra|
      orchestra.photo.attach(io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")), filename: "orchestra.jpg", content_type: "image/jpg")
    end
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id               :uuid             not null, primary key
#  name             :string           not null
#  rank             :integer          default(0), not null
#  sort_name        :string
#  birth_date       :date
#  death_date       :date
#  slug             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recordings_count :integer          default(0)
#
