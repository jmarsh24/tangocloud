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
