FactoryBot.define do
  factory :external_catalog_el_recodo_song, class: "ExternalCatalog::ElRecodo::Song" do
    date { Faker::Date.between(from: "1900-01-01", to: "2020-12-31") }
    ert_number { Faker::Number.number(digits: 4) }
    title { Faker::Music::Opera.verdi }
    style { Faker::Music.genre }
    label { Faker::Music.album }
    lyrics { Faker::Lorem.paragraph }
    lyrics_year { Faker::Number.number(digits: 4) }
    synced_at { Faker::Time.backward(days: 14, period: :evening) }
    page_updated_at { Faker::Time.backward(days: 7, period: :evening) }
  end
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_songs
#
#  id              :uuid             not null, primary key
#  date            :date             not null
#  ert_number      :integer          default(0), not null
#  title           :string           not null
#  style           :string
#  label           :string
#  instrumental    :boolean          default(TRUE), not null
#  lyrics          :text
#  lyrics_year     :integer
#  search_data     :string
#  matrix          :string
#  disk            :string
#  speed           :integer
#  duration        :integer
#  synced_at       :datetime         not null
#  page_updated_at :datetime
#  orchestra_id    :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  formatted_title :string
#