class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  searchkick word_middle: [:title, :description]

  has_many :audio_transfers, dependent: :destroy

  enum album_type: {compilation: "compilation", original: "original"}

  validates :title, presence: true
  validates :audio_transfers_count, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :slug, presence: true, uniqueness: true

  has_one_attached :album_art, dependent: :purge_later do |blob|
    blob.variant :thumb, resize_to_limit: [100, 100]
    blob.variant :medium, resize_to_limit: [250, 250]
    blob.variant :large, resize_to_limit: [500, 500]
  end

  def self.search_albums(query = "*")
    search(
      query,
      fields: [:title, :description],
      match: :word_middle,
      misspellings: {below: 5},
      order: {title: :asc},
      includes: [
        album_art_attachment: :blob
      ]
    )
  end

  def search_data
    {
      title: title,
      description: description
    }
  end
end

# == Schema Information
#
# Table name: albums
#
#  id                    :uuid             not null, primary key
#  title                 :string           not null
#  description           :text
#  release_date          :date
#  audio_transfers_count :integer          default(0), not null
#  slug                  :string           not null
#  external_id           :string
#  album_type            :enum             default("compilation"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
