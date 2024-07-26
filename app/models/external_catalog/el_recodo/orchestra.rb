module ExternalCatalog
  module ElRecodo
    class Orchestra < ApplicationRecord
      searchkick word_start: [:name], callbacks: :async

      validates :name, presence: true, uniqueness: true

      has_many :songs,
        dependent: :destroy,
        inverse_of: :el_recodo_orchestra, class_name: "ExternalCatalog::ElRecodo::Song"

      has_many :person_roles,
        through: :el_recodo_songs,
        source: :el_recodo_person_roles, class_name: "ExternalCatalog::ElRecodo::PersonRole"

      has_many :people,
        through: :el_recodo_person_roles,
        source: :el_recodo_person,
        as: :members, class_name: "ExternalCatalog::ElRecodo::Person"

      has_one_attached :image

      def search_data
        {
          name:
        }
      end
    end

    # == Schema Information
    #
    # Table name: el_recodo_orchestras
    #
    #  id         :uuid             not null, primary key
    #  name       :string           default(""), not null
    #  created_at :datetime         not null
    #  updated_at :datetime         not null
    #
  end
end
