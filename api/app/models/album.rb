class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :audio_transfers, through: :album_audio_transfers
  has_many :recordings, through: :audio_transfers

  enum album_type: {compilation: "compilation", original: "original"}

  validates :title, presence: true
  validates :recordings_count, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :slug, presence: true, uniqueness: true

  has_one_attached :album_art, dependent: :purge_later do |blob|
    blob.variant :thumb, resize: "100x100"
    blob.variant :medium, resize: "300x300"
    blob.variant :large, resize: "500x500"
  end

  class << self
    def search(query)
      return all if query.blank?

      sanitized_query = sanitize_sql_like(query.downcase)
      select("*, similarity(title, '#{sanitized_query}') AS similarity")
        .where("title % ?", sanitized_query)
        .order("similarity DESC")
    end
  end
end

# == Schema Information
#
# Table name: albums
#
#  id               :uuid             not null, primary key
#  title            :string           not null
#  description      :text
#  release_date     :date
#  recordings_count :integer          default(0), not null
#  slug             :string           not null
#  external_id      :string
#  album_type       :enum             default("compilation"), not null
#
