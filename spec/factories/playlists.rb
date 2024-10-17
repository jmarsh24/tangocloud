FactoryBot.define do
  factory :playlist do
    title { Faker::Music.album }
    subtitle { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    public { true }
    system { false }
    user

    before(:create) do |playlist|
      playlist.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/album-art-volver-a-sonar.jpg")),
        filename: "album-art-volver-a-sonar.jpg",
        content_type: "image/jpeg"
      )
      playlist.playlist_file.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/awesome_playlist.m3u8")),
        filename: "awesome_playlist.m3u8",
        content_type: "application/x-mpegURL"
      )
    end

    # Trait to include items after creating the playlist
    trait :with_items do
      after(:create) do |playlist|
        create_list(:playlist_item, 5, playlistable: playlist)  # Ensure playlistable is used
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

# == Schema Information
#
# Table name: playlists
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  subtitle    :string
#  description :text
#  slug        :string
#  public      :boolean          default(TRUE), not null
#  system      :boolean          default(FALSE), not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
