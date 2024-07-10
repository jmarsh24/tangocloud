# == Schema Information
#
# Table name: recordings
#
#  id                :uuid             not null, primary key
#  recorded_date     :date
#  slug              :string           not null
#  recording_type    :enum             default("studio"), not null
#  listens_count     :integer          default(0), not null
#  el_recodo_song_id :uuid
#  orchestra_id      :uuid             not null
#  composition_id    :uuid             not null
#  record_label_id   :uuid
#  genre_id          :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  searchkick word_start: [:title, :orchestra_name, :singer_name]

  belongs_to :orchestra
  belongs_to :composition
  belongs_to :record_label, optional: true
  belongs_to :genre
  belongs_to :el_recodo_song, optional: true
  belongs_to :time_period, optional: true
  has_many :recording_singers, dependent: :destroy
  has_many :singers, through: :recording_singers, source: :person
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :listens, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :tanda_recordings, dependent: :destroy
  has_many :digital_remasters, dependent: :destroy
  has_many :audio_variants, through: :digital_remasters
  has_many :lyrics, through: :composition
  has_many :tanda_recordings, dependent: :destroy
  has_many :tandas, through: :tanda_recordings
  has_many :waveforms, through: :digital_remasters

  validates :recorded_date, presence: true
  validates :composition, presence: true
  validates :orchestra, presence: true
  validates :genre, presence: true

  enum recording_type: {studio: "studio", live: "live"}

  def search_data
    {
      title: composition.title,
      composer_names: composition&.composers&.map(&:name),
      lyricist_names: composition&.lyricists&.map(&:name),
      orchestra_name: orchestra&.name,
      singer_names: singers.map(&:name).join(" "),
      genre: genre&.name,
      listens_count:,
      year: recorded_date.year,
      created_at:,
      updated_at:
    }
  end

  def title
    composition.title
  end
end
