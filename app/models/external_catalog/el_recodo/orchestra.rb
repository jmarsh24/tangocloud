module ExternalCatalog
  module ElRecodo
    class Orchestra < ApplicationRecord
      searchkick word_start: [:name], callbacks: :async

      validates :name, presence: true, uniqueness: true

      has_many :songs,
        dependent: :destroy,
        inverse_of: :orchestra,
        class_name: "ExternalCatalog::ElRecodo::Song"

      has_many :person_roles,
        through: :songs,
        class_name: "ExternalCatalog::ElRecodo::PersonRole"

      has_many :people,
        through: :person_roles,
        class_name: "ExternalCatalog::ElRecodo::Person"

      has_one_attached :image

      def search_data
        {
          name:
        }
      end
    end
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  sort_name  :string
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
