class Singer < ApplicationRecord
  extend FriendlyId
  include Titleizable
  friendly_id :name, use: :slugged
  searchkick word_middle: [:name], callbacks: :async

  has_many :recording_singers, dependent: :destroy
  has_many :recordings, through: :recording_singers

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :rank, presence: true, numericality: {only_integer: true}
  validates :normalized_name, presence: true, uniqueness: true

  has_one_attached :photo, dependent: :purge_later do |blob|
    blob.variant :thumb, resize_to_limit: [100, 100]
    blob.variant :medium, resize_to_limit: [250, 250]
    blob.variant :large, resize_to_limit: [500, 500]
  end

  before_save :set_normalized_name

  def self.search_singers(query = "*")
    search(query,
      fields: ["name^5"],
      match: :word_middle,
      misspellings: {below: 5})
  end

  def search_data
    {
      name:
    }
  end

  def set_normalized_name
    self.normalized_name = I18n.transliterate(name).downcase
  end
end

# == Schema Information
#
# Table name: singers
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  slug            :string           not null
#  rank            :integer          default(0), not null
#  sort_name       :string
#  bio             :text
#  birth_date      :date
#  death_date      :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  soloist         :boolean          default(FALSE)
#  normalized_name :string
#
