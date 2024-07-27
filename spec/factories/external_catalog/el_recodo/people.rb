FactoryBot.define do
  factory :external_catalog_el_recodo_person, class: "ExternalCatalog::ElRecodo::Person" do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    death_date { Faker::Date.birthday(min_age: 65, max_age: 100) }
    real_name { Faker::Name.name }
    nicknames { Faker::Name.name }
    place_of_birth { Faker::Address.city }
    path { Faker::Internet.slug }
    synced_at { Faker::Date.birthday(min_age: 1, max_age: 5) }
  end
end
