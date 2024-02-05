class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :audio_transfers, dependent: :destroy

  enum album_type: { compilation: 0, original: 1 }

  validates :title, presence: true
  validates :audio_transfers_count, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :slug, presence: true, uniqueness: true

  has_one_attached :album_art, dependent: :purge_later do |blob|
    blob.variant :thumb, resize: "100x100"
    blob.variant :medium, resize: "300x300"
    blob.variant :large, resize: "500x500"
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
#
