class Singer < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged
  searchkick word_start: [:first_name, :last_name, :name], callbacks: :async

  has_many :recording_singers, dependent: :destroy
  has_many :recordings, through: :recording_singers

  validates :first_name, presence: true
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :rank, presence: true, numericality: {only_integer: true}

  before_create :assign_names

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

  def assign_names
    formatted_name = self.class.custom_titleize(name)
    names = formatted_name.split(" ")
    self[:name] = formatted_name
    self.first_name = names.first
    self.last_name = (names.length > 1) ? names.last : ""
    self.sort_name = (names.length > 1) ? names.last : ""
  end
end

# == Schema Information
#
# Table name: singers
#
#  id         :uuid             not null, primary key
#  first_name :string           not null
#  last_name  :string
#  name       :string           not null
#  slug       :string           not null
#  rank       :integer          default(0), not null
#  sort_name  :string
#  bio        :text
#  birth_date :date
#  death_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  soloist    :boolean          default(FALSE)
#
