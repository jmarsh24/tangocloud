FactoryBot.define do
  factory :external_catalog_el_recodo_person_role, class: "ExternalCatalog::ElRecodo::PersonRole" do
    role { Faker::Music.band }
    el_recodo_person { build(:external_catalog_el_recodo_person) }
    el_recodo_song { build(:external_catalog_el_recodo_song) }
  end
end
