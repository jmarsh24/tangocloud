class Orchestra < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged

  searchkick word_start: [:first_name, :last_name, :name], callbacks: :async

  has_many :recordings, dependent: :destroy
  has_many :singers, through: :recordings
  has_many :compositions, through: :recordings
  has_many :composers, through: :compositions
  has_many :lyricists, through: :compositions

  validates :first_name, presence: true
  validates :rank, presence: true, numericality: {only_integer: true}
  validates :slug, presence: true, uniqueness: true

  before_validation :assign_names, on: :create

  has_one_attached :photo, dependent: :purge_later do |blob|
    blob.variant :thumb, resize_to_limit: [100, 100]
    blob.variant :medium, resize_to_limit: [250, 250]
    blob.variant :large, resize_to_limit: [500, 500]
  end

  def search_data
    {
      first_name:,
      last_name:,
      name:
    }
  end

  private

  def assign_names
    if new_record?
      formatted_name = self.class.custom_titleize(name)
      names = formatted_name.split(" ")
      self.name ||= formatted_name
      self.first_name ||= names.first
      self.last_name ||= (names.length > 1) ? names.last : ""
      self.sort_name ||= (names.length > 1) ? names.last : ""
    end
  end
end

# == Schema Information
#
# Table name: orchestras
#
#  id               :uuid             not null, primary key
#  first_name       :string           not null
#  last_name        :string
#  name             :string           not null
#  rank             :integer          default(0), not null
#  sort_name        :string
#  birth_date       :date
#  death_date       :date
#  slug             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recordings_count :integer          default(0)
#
