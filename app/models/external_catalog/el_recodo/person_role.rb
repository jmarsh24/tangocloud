module ExternalCatalog
  module ElRecodo
    class PersonRole < ApplicationRecord
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
        "cello"
      ].freeze

      validates :role, inclusion: {in: ROLES}

      normalizes :role, with: ->(value) { value.to_s.downcase }
    end
  end
end
