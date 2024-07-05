FactoryBot.define do
  factory :el_recodo_song do
    date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
    ert_number { Faker::Number.number(digits: 4) }
    music_id { Faker::Number.unique.number(digits: 5) }
    title { Faker::Music::Opera.verdi }
    style { Faker::Music.genre }
    orchestra { Faker::Music.band }
    singer { Faker::Name.name }
    soloist { Faker::Name.name }
    director { Faker::Name.name }
    composer { Faker::Name.name }
    author { Faker::Name.name }
    label { Faker::Music.album }
    lyrics { Faker::Lorem.paragraph }
    synced_at { Faker::Time.backward(days: 14, period: :evening) }
    page_updated_at { Faker::Time.backward(days: 7, period: :evening) }

    after(:build) do |el_recodo_song|
      el_recodo_song.recording ||= create(:recording, el_recodo_song:)
    end
  end
end

# == Schema Information
#
# Table name: el_recodo_songs
#
#  id                   :uuid             not null, primary key
#  date                 :date             not null
#  ert_number           :integer          default(0), not null
#  music_id             :integer          default(0), not null
#  title                :string           not null
#  style                :string
#  orchestra            :string
#  singer               :string
#  soloist              :string
#  director             :string
#  composer             :string
#  author               :string
#  label                :string
#  lyrics               :text
#  normalized_title     :string
#  normalized_orchestra :string
#  normalized_singer    :string
#  normalized_composer  :string
#  normalized_author    :string
#  search_data          :string
#  synced_at            :datetime         not null
#  page_updated_at      :datetime         not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
