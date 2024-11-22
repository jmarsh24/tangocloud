class AcrCloudRecognition < ApplicationRecord
  belongs_to :digital_remaster
  has_many :external_identifiers, dependent: :destroy

  validates :status, presence: true, inclusion: {in: %w[pending processing completed failed]}
  validates :metadata, presence: true

  store_attribute :metadata, :track_title, :string
  store_attribute :metadata, :artist_name, :string
  store_attribute :metadata, :album_name, :string
  store_attribute :metadata, :recognition_score, :float
  store_attribute :metadata, :isrc, :string
  store_attribute :metadata, :iswc, :string
  store_attribute :metadata, :musicbrainz_id, :string
  store_attribute :metadata, :deezer_id, :string
  store_attribute :metadata, :spotify_id, :string
  store_attribute :metadata, :youtube_vid, :string
  store_attribute :metadata, :duration_ms, :integer
  store_attribute :metadata, :release_date, :string
  store_attribute :metadata, :label, :string
  store_attribute :metadata, :genres, :string, array: true

  enum :status, {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }

  def success?
    status == "completed" && recognition_score.present? && recognition_score > 0.8
  end
end
