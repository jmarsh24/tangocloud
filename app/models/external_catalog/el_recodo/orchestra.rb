class ExternalCatalog::ElRecodo::Orchestra < ApplicationRecord
  searchkick word_start: [:name], callbacks: :async

  validates :name, presence: true, uniqueness: true

  has_many :songs, dependent: :destroy, inverse_of: :orchestra, class_name: "ExternalCatalog::ElRecodo::Song"

  has_many :person_roles, through: :songs, source: :person_roles, class_name: "ExternalCatalog::ElRecodo::PersonRole"
  has_many :people, through: :person_roles, source: :person, class_name: "ExternalCatalog::ElRecodo::Person"

  has_one_attached :image

  def search_data
    {
      name:
    }
  end
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_orchestras
#
#  id         :integer          not null, primary key
#  name       :string           default(""), not null
#  path       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
