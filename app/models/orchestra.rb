class Orchestra < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  searchkick word_start: [:name]

  belongs_to :el_recodo_orchestra, class_name: "ExternalCatalog::ElRecodo::Orchestra", optional: true
  has_many :orchestra_periods, dependent: :destroy
  has_many :orchestra_positions, dependent: :destroy
  has_many :orchestra_roles, through: :orchestra_positions
  has_many :recordings, dependent: :destroy
  has_many :compositions, through: :recordings
  has_many :singers, through: :recordings
  has_many :genres, through: :recordings

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  has_one_attached :image

  before_save :set_normalized_name

  def self.find_or_create_by_normalized_name!(name)
    normalized_name = NameUtils::NameNormalizer.normalize(name)
    find_or_create_by!(normalized_name:) do |orchestra|
      orchestra.name = NameUtils::NameFormatter.format(name)
    end
  end

  def export_filename
    "#{name.parameterize}_#{id}"
  end

  private

  def set_normalized_name
    self.normalized_name = NameUtils::NameNormalizer.normalize(name)
  end

  def search_data
    {
      id:,
      name:,
      periods: orchestra_periods.pluck(:name),
      roles: orchestra_roles.pluck(:name),
      singers: singers.pluck(:name),
      genres: genres.pluck(:name)
    }
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id                     :uuid             not null, primary key
#  name                   :string           not null
#  sort_name              :string
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  el_recodo_orchestra_id :uuid
#  normalized_name        :string
#
