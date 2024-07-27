class ExternalCatalog::ElRecodo::PersonRole < ApplicationRecord
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_person_roles
#
#  id                                   :uuid             not null, primary key
#  external_catalog_el_recodo_person_id :uuid             not null
#  external_catalog_el_recodo_song_id   :uuid             not null
#  role                                 :string           not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
