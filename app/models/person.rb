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
  validates :normalized_name, presence: true, uniqueness: true

  has_one_attached :image

  before_validation :set_normalized_name, unless: -> { normalized_name.present? }

  before_save :set_display_name, if: -> { display_name.blank? }

  scope :search_import, -> { includes(:composition_roles, :recording_singers) }

  class << self
    def find_or_create_by_normalized_name!(name)
      normalized_name = NameUtils::NameNormalizer.normalize(name)

      find_or_create_by!(normalized_name:) do |person|
        parsed_name = NameUtils::NameParser.parse(name)
        person.name = parsed_name.formatted_name
        person.pseudonym = parsed_name.pseudonym
        person.normalized_name = normalized_name
      end
    end
  end

  def export_filename
    "#{name.parameterize}_#{id}"
  end

  private

  def set_display_name
    self.display_name = name
  end

  def set_normalized_name
    self.normalized_name = NameUtils::NameNormalizer.normalize(name)
  end

  def search_data
    {
      name:,
      composition_roles: composition_roles.map(&:role),
      singer: recording_singers.any?,
      normalized_name:
    }
  end
end

# == Schema Information
#
# Table name: people
#
#  id                  :uuid             not null, primary key
#  name                :string           default(""), not null
#  slug                :string
#  sort_name           :string
#  nickname            :string
#  birth_place         :string
#  normalized_name     :string           default(""), not null
#  pseudonym           :string
#  bio                 :text
#  birth_date          :date
#  death_date          :date
#  el_recodo_person_id :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
