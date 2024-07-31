class ExternalCatalog::ElRecodo::PersonRole < ApplicationRecord
  belongs_to :person, class_name: "ExternalCatalog::ElRecodo::Person"
  belongs_to :song, class_name: "ExternalCatalog::ElRecodo::Song"

  validates :person, presence: true
  validates :role, presence: true

  ROLES = [
    "piano",
    "arranger",
    "doublebass",
    "bandoneon",
    "violin",
    "singer",
    "soloist",
    "director",
    "composer",
    "author",
    "cello",
    "viola"
  ].freeze

  validates :role, inclusion: {in: ROLES}

  normalizes :role, with: ->(value) { value.to_s.downcase }

  scope :singers, -> { where(role: "singer").distinct }
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
