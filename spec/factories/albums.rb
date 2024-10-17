FactoryBot.define do
  factory :album do
    title { Faker::Music.album }
    description { Faker::Lorem.paragraph }
    release_date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }

    after(:build) do |album|
      album.album_art.attach(
        io: File.open(Rails.root.join("spec/support/assets/album_art.jpg")),
        filename: "album_art.jpg",
        content_type: "image/jpg"
      )
    end
  end
end

# == Schema Information
#
# Table name: albums
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text
#  release_date :date
#  external_id  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
