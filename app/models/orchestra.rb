class Orchestra < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  searchkick word_start: [:name, :first_name, :last_name]

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

  scope :ordered_by_recordings, -> { order(recordings_count: :desc) }

  scope :search_import, -> { includes(:orchestra_periods, :orchestra_roles, :singers, :genres) }

  before_save :set_display_name, if: -> { display_name.blank? }

  class << self
    def find_or_create_by_normalized_name!(name)
      normalized_name = NameUtils::NameNormalizer.normalize(name)
      find_or_create_by!(normalized_name:) do |orchestra|
        orchestra.name = NameUtils::NameFormatter.format(name)
      end
    end
  end

  def export_filename
    "#{name.parameterize}_#{id}"
  end

  private

  def set_normalized_name
    self.normalized_name = NameUtils::NameNormalizer.normalize(name)
  end

  private

  def search_data
    {
      id:,
      name: normalized_name,
      first_name: normalized_name.split.first,
      last_name: normalized_name.split.last
    }
  end

  def set_display_name
    self.display_name = name
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id                     :uuid             not null, primary key
#  name                   :string           not null
#  sort_name              :string
#  normalized_name        :string           default(""), not null
#  el_recodo_orchestra_id :uuid
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  recordings_count       :integer
#  display_name           :string
#
