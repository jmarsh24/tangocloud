class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  searchkick word_middle: [:title, :composer_name, :author, :lyrics, :orchestra_name, :singer_name]

  belongs_to :el_recodo_song, optional: true
  belongs_to :orchestra, counter_cache: true
  belongs_to :composition, optional: true, counter_cache: true
  belongs_to :record_label, optional: true
  belongs_to :genre, counter_cache: true
  belongs_to :period, optional: true, counter_cache: true
  belongs_to :el_recodo_song, optional: true
  has_many :audio_transfers, dependent: :destroy
  has_many :audio_variants, through: :audio_transfers, dependent: :destroy
  has_many :recording_singers, dependent: :destroy
  has_many :singers, through: :recording_singers, dependent: :destroy
  has_many :lyrics, through: :composition
  has_many :tanda_recordings, dependent: :destroy
  has_many :tandas, through: :tanda_recordings
  has_many :waveforms, through: :audio_transfers, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :playbacks, dependent: :destroy
  has_many :users, through: :playbacks

  validates :title, presence: true
  validates :recorded_date, presence: true

  enum recording_type: {studio: "studio", live: "live"}

  def self.search_recordings(query)
    if query.blank? || query == "*"
      Recording.includes(
        :orchestra,
        :singers,
        :composition,
        :genre,
        :period,
        :lyrics,
        :audio_variants,
        audio_transfers: [album: {album_art_attachment: :blob}]
      ).order(playbacks_count: :desc).limit(100)
    else
      Recording.search(query,
        fields: [
          "title",
          "composer_names",
          "lyricist_names",
          "lyrics",
          "orchestra_name",
          "singer_names",
          "genre",
          "period",
          "recorded_date"
        ],
        match: :word_middle,
        misspellings: {below: 5},
        order: {playbacks_count: :desc},
        boost_by: [:playbacks_count],
        includes: [
          :orchestra,
          :singers,
          :composition,
          :genre,
          :period,
          :lyrics,
          :audio_variants,
          audio_transfers: [album: {album_art_attachment: :blob}]
        ])
    end
  end

  def search_data
    {
      title:,
      composer_names: composition&.composer&.name,
      lyricist_names: composition&.lyricist&.name,
      lyrics: lyrics.map(&:content),
      orchestra_name: orchestra&.name,
      singer_names: singers.map(&:name).join(" "),
      genre: genre&.name,
      period: period&.name,
      playbacks_count:
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
#  el_recodo_song_id :uuid
#  orchestra_id      :uuid
#  singer_id         :uuid
#  composition_id    :uuid
#  record_label_id   :uuid
#  genre_id          :uuid
#  period_id         :uuid
#  playbacks_count   :integer          default(0)
#
