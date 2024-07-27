FactoryBot.define do
  factory :external_catalog_el_recodo_orchestra, class: "ExternalCatalog::ElRecodo::Orchestra" do
    name { Faker::Music.band }
  end
end
