FactoryBot.define do
  factory :external_catalog_el_recodo_orchestra, class: "ExternalCatalog::ElRecodo::Orchestra" do
    name { Faker::Music.band }
  end
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_orchestras
#
#  id         :uuid             not null, primary key
#  name       :string           default(""), not null
#  path       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
