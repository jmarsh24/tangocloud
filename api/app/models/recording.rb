class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  searchkick word_start: [:title, :orchestra_name, :singer_name]

  belongs_to :el_recodo_song, optional: true
  belongs_to :orchestra
  belongs_to :composition, optional: true
  belongs_to :record_label, optional: true
  belongs_to :genre
  belongs_to :el_recodo_song, optional: true
  has_many :audio_transfers, dependent: :destroy
  has_many :recording_singers, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :listens, dependent: :destroy
  has_many :mood_tags, dependent: :destroy
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :tanda_recordings, dependent: :destroy
  has_many :time_periods, as: :timeable, dependent: :destroy
  has_many :singers, through: :recording_singers

  validates :title, presence: true
  validates :recorded_date, presence: true

  enum recording_type: {studio: "studio", live: "live"}

  def search_data
    {
      title:,
      composer_names: composition&.composer&.name,
      lyricist_names: composition&.lyricist&.name,
      orchestra_name: orchestra&.name,
      singer_names: singers.map(&:name).join(" "),
      genre: genre&.name,
      time_periods: time_periods.map(&:name),
      playbacks_count:,
      year: recorded_date.year,
      created_at:,
      updated_at:
    }
  end
end

# == Schema Information
#
# Table name: recordings
#
#  id                :uuid             not null, primary key
#  title             :string           not null
#  bpm               :integer
#  release_date      :date
#  recorded_date     :date
#  slug              :string           not null
#  recording_type    :enum             default("studio"), not null
#  playbacks_count   :integer          default(0), not null
#  el_recodo_song_id :uuid
#  orchestra_id      :uuid
#  singer_id         :uuid
#  composition_id    :uuid
#  record_label_id   :uuid
#  genre_id          :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
