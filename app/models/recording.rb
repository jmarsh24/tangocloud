class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  searchkick word_start: [:title, :orchestra_name, :singer_name]

  belongs_to :orchestra, optional: true
  belongs_to :composition
  belongs_to :record_label, optional: true
  belongs_to :genre
  belongs_to :el_recodo_song, class_name: "ExternalCatalog::ElRecodo::Song", optional: true
  belongs_to :time_period, optional: true
  has_many :recording_singers, dependent: :destroy
  has_many :singers, through: :recording_singers, source: :person
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :playbacks, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :shares, as: :shareable, dependent: :destroy
  has_many :digital_remasters, dependent: :destroy
  has_many :audio_variants, through: :digital_remasters
  has_many :lyrics, through: :composition
  has_many :playlist_items, dependent: :destroy
  has_many :tandas, through: :playlist_items
  has_many :waveforms, through: :digital_remasters

  validates :recorded_date, presence: true

  enum :recording_type, {studio: 0, live: 1}

  scope :search_import, -> {
                          includes(
                            :composition,
                            :orchestra,
                            :singers,
                            :genre,
                            :record_label,
                            :time_period,
                            composition: [:composers, :lyricists],
                            orchestra: [:orchestra_periods]
                          )
                        }

  def title
    composition.title
  end

  def year
    recorded_date&.year
  end

  private

  def search_data
    {
      title: composition.title,
      composers: composition&.composers&.map(&:name),
      lyricists: composition&.lyricists&.map(&:name),
      orchestra_periods: orchestra&.orchestra_periods&.map(&:name),
      orchestra: orchestra&.name,
      singers: singers.present? ? singers.map(&:name) : "Inst",
      genre: genre&.name,
      playbacks_count:,
      year:,
      created_at:,
      updated_at:,
      time_period: time_period&.name,
      record_label: record_label&.name,
      slug:
    }
  end
end

# == Schema Information
#
# Table name: recordings
#
#  id                :integer          not null, primary key
#  recorded_date     :date
#  slug              :string           not null
#  recording_type    :integer          default("studio"), not null
#  playbacks_count   :integer          default(0), not null
#  el_recodo_song_id :integer
#  orchestra_id      :integer
#  composition_id    :integer          not null
#  genre_id          :integer          not null
#  record_label_id   :integer
#  time_period_id    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
