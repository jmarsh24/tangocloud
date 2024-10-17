class ExternalCatalog::ElRecodo::Person < ApplicationRecord
  searchkick word_start: [:name, :real_name, :nicknames, :place_of_birth], callbacks: :async

  has_many :person_roles, class_name: "ExternalCatalog::ElRecodo::PersonRole", dependent: :destroy
  has_many :songs, through: :person_roles, source: :song, class_name: "ExternalCatalog::ElRecodo::Song", inverse_of: :people

  has_one_attached :image

  validates :name, presence: true

  private

  def search_data
    {
      name:,
      real_name:,
      nicknames:,
      place_of_birth:
    }
  end
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_people
#
#  id             :integer          not null, primary key
#  name           :string           default(""), not null
#  birth_date     :date
#  death_date     :date
#  real_name      :string
#  nicknames      :string           default("[]"), not null
#  place_of_birth :string
#  path           :string
#  synced_at      :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
