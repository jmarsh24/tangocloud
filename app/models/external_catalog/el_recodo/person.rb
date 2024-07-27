class ExternalCatalog::ElRecodo::Person < ApplicationRecord
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
