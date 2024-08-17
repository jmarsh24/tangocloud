class Person < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  searchkick word_start: [:name]

  belongs_to :el_recodo_person, class_name: "ExternalCatalog::ElRecodo::Person", optional: true
  has_many :composition_roles, dependent: :destroy
  has_many :compositions, through: :composition_roles
  has_many :orchestra_positions, dependent: :destroy
  has_many :orchestras, through: :orchestra_roles
  has_many :recording_singers, dependent: :destroy
  has_many :recordings, through: :recording_singers

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_one_attached :image

  def search_data
    {
      name:,
      composition_roles: composition_roles.map(&:role),
      singer: recording_singers.any?
    }
  end

  def export_filename
    "#{name.parameterize}_#{id}"
  end
end

# == Schema Information
#
# Table name: people
#
#  id                  :uuid             not null, primary key
#  name                :string           not null
#  slug                :string           not null
#  sort_name           :string
#  bio                 :text
#  birth_date          :date
#  death_date          :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  nickname            :string
#  birth_place         :string
#  el_recodo_person_id :uuid
#
