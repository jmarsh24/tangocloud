FactoryBot.define do
  factory :playlist do
    title { Faker::Music.album }
    subtitle { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    public { true }
    system { false }
    association :user

    before(:create) do |playlist|
      playlist.image.attach(io: File.open(Rails.root.join("spec/support/assets/album-art.jpg")), filename: "album-art.jpg", content_type: "image/jpg")
      playlist.playlist_file.attach(io: File.open(Rails.root.join("spec/support/assets/playlist.m3u8")), filename: "playlist.m3u8", content_type: "application/x-mpegURL")
    end

    trait :with_items do
      after(:create) do |playlist|
        create_list(:playlist_item, 5, playlist:)
      end
    end

    trait :public do
      public { true }
    end

    trait :private do
      public { false }
    end

    trait :system do
      system { true }
    end
  end
end
