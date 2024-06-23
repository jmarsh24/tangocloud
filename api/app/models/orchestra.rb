class Orchestra < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged

  searchkick word_middle: [:name], callbacks: :async

  has_many :recordings, dependent: :destroy
  has_many :singers, through: :recordings
  has_many :compositions, through: :recordings
  has_many :composers, through: :compositions
  has_many :lyricists, through: :compositions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :rank, presence: true, numericality: {only_integer: true}
  validates :slug, presence: true, uniqueness: true

  has_one_attached :photo, dependent: :purge_later do |blob|
    blob.variant :thumb, resize_to_limit: [100, 100]
    blob.variant :medium, resize_to_limit: [250, 250]
    blob.variant :large, resize_to_limit: [500, 500]
  end

  def search_data
    {
      name:
    }
  end

  def name
    "#{first_name} #{last_name}"
  end

  def formatted_name
    self.class.custom_titleize(name)
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id               :uuid             not null, primary key
#  first_name       :string           not null
#  last_name        :string           not null
#  rank             :integer          default(0), not null
#  sort_name        :string
#  birth_date       :date
#  death_date       :date
#  slug             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recordings_count :integer          default(0)
#  normalized_name  :string
#
