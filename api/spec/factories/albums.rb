FactoryBot.define do
  factory :album do
    title { Faker::Music.album }
    description { Faker::Lorem.paragraph }
    release_date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
    audio_transfers_count { 0 }
    slug { Faker::Internet.slug(words: title, glue: "-") }
    album_type { Album.album_types.keys.sample }

    after(:build) do |album|
      album.album_art.attach(
        io: File.open(Rails.root.join("spec/support/assets/album_art.png")),
        filename: "album_art.png",
        content_type: "image/png"
      )
    end
  end
end
