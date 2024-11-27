FactoryBot.define do
  factory :tanda do
    title { Faker::Music.album }
    subtitle { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    public { true }
    system { false }
    user

    before(:create) do |tanda|
      tanda.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/album-art-volver-a-sonar.jpg")),
        filename: "album-art-volver-a-sonar.jpg",
        content_type: "image/jpeg"
      )
      tanda.playlist_file.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/awesome_tanda.m3u8")),
        filename: "awesome_tanda.m3u8",
        content_type: "application/x-mpegURL"
      )
    end

    trait :with_items do
      after(:create) do |tanda|
        create_list(:playlist_item, 3, playlist: tanda)
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
# Table name: tandas
#
#  id               :uuid             not null, primary key
#  title            :string           not null
#  subtitle         :string
#  description      :text
#  public           :boolean          default(TRUE), not null
#  system           :boolean          default(FALSE), not null
#  user_id          :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  playlists_count  :integer          default(0), not null
#  slug             :string
#  recordings_count :integer          default(0), not null
#  duration         :integer          default(0), not null
#
