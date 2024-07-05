FactoryBot.define do
  factory :lyricist do
    name { Faker::Name.name }
    slug { Faker::Internet.slug(words: name, glue: "-") }
    birth_date { Faker::Date.between(from: "1850-01-01", to: "1950-12-31") }
    death_date { Faker::Date.between(from: "1900-01-01", to: "2000-12-31") }
    bio { Faker::Lorem.paragraph }

    after(:build) do |lyricist|
      lyricist.photo.attach(io: File.open(Rails.root.join("spec/support/assets/orchestra.jpg")), filename: "orchestra.jpg", content_type: "image/jpg")
    end
  end
end

# == Schema Information
#
# Table name: lyricists
#
#  id                 :uuid             not null, primary key
#  name               :string           not null
#  slug               :string           not null
#  sort_name          :string
#  birth_date         :date
#  death_date         :date
#  bio                :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  compositions_count :integer          default(0)
#
