class ExternalIdentifier < ApplicationRecord
  belongs_to :recording
  belongs_to :acr_cloud_recognition

  store_attribute :metadata, :track_title, :string
  store_attribute :metadata, :artist_name, :string
  store_attribute :metadata, :album_name, :string
  store_attribute :metadata, :confidence_score, :float
  store_attribute :metadata, :isrc, :string
  store_attribute :metadata, :iswc, :string
  store_attribute :metadata, :musicbrainz_id, :string
  store_attribute :metadata, :deezer_id, :string
  store_attribute :metadata, :spotify_id, :string
  store_attribute :metadata, :youtube_vid, :string

  validates :track_title, presence: true
  validates :confidence_score, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
end

# == Schema Information
#
# Table name: external_identifiers
#
#  id                       :uuid             not null, primary key
#  recording_id             :uuid             not null
#  acr_cloud_recognition_id :uuid
#  service_name             :string           not null
#  external_id              :string           not null
#  metadata                 :jsonb
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
