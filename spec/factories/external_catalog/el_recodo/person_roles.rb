FactoryBot.define do
  factory :external_catalog_el_recodo_person_role, class: "ExternalCatalog::ElRecodo::PersonRole" do
    role { Faker::Music.band }
    el_recodo_person { build(:external_catalog_el_recodo_person) }
    el_recodo_song { build(:external_catalog_el_recodo_song) }
  end
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_person_roles
#
#  id         :uuid             not null, primary key
#  person_id  :uuid             not null
#  song_id    :uuid             not null
#  role       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
