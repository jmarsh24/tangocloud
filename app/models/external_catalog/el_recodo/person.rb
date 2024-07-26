module ExternalCatalog
  module ElRecodo
    class Person < ApplicationRecord
      searchkick word_start: [:name, :real_name, :nicknames, :place_of_birth], callbacks: :async

      has_many :person_roles, dependent: :destroy, class_name: "ExternalCatalog::ElRecodo::PersonRole"
      has_many :songs, through: :el_recodo_person_roles, class_name: "ExternalCatalog::ElRecodo::Song"

      has_one_attached :image

      validates :name, presence: true

      def search_data
        {
          name:,
          real_name:,
          nicknames:,
          place_of_birth:
        }
      end
    end
  end
end
# == Schema Information
#
# Table name: people
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
