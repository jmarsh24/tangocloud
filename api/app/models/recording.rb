class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  searchkick word_start: [:title, :orchestra_name, :singer_name]

  belongs_to :orchestra
  belongs_to :composition, optional: true
  belongs_to :record_label, optional: true
  belongs_to :genre
  belongs_to :el_recodo_song, optional: true
  belongs_to :time_period, optional: true
  has_many :audio_transfers, dependent: :destroy
  has_many :recording_singers, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :listens, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :tanda_recordings, dependent: :destroy
  has_many :singers, through: :recording_singers

  validates :title, presence: true
  validates :recorded_date, presence: true

  enum recording_type: {studio: "studio", live: "live"}

  def search_data
    {
      title: title,
      composer_names: composition&.composer&.name,
      lyricist_names: composition&.lyricist&.name,
      orchestra_name: orchestra&.name,
      singer_names: singers.map(&:name).join(" "),
      genre: genre&.name,
      listens_count: listens_count,
      year: recorded_date.year,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
