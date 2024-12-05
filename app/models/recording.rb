class Recording < ApplicationRecord
  searchkick word_start: [:title, :orchestra, :orchestra_display_name, :singer_name, :composers, :lyricists, :orchestra_periods, :genre],
    text_middle: [:combined],
    filterable: [:orchestra, :singer, :genre],
    callbacks: :async

  belongs_to :orchestra, optional: true, counter_cache: true
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
  has_many :playlist_items, as: :item, dependent: :destroy
  has_many :tandas, through: :playlist_items
  has_many :waveforms, through: :digital_remasters
  has_many :tanda_recordings, dependent: :destroy
  has_many :tandas, through: :tanda_recordings
  has_many :external_identifiers, dependent: :destroy
  has_many :recording_services, dependent: :destroy

  after_create_commit :set_year

  validates :recorded_date, presence: true

  enum :recording_type, {studio: "studio", live: "live"}

  delegate :title, to: :composition

  default_scope { includes(:composition) }

  scope :with_associations, -> {
    includes(:composition, :orchestra, :singers, :genre, digital_remasters:
    [audio_variants: [audio_file_attachment: :blob],
     album: [album_art_attachment: :blob]])
  }

  def liked_by?(user)
    likes.exists?(user:)
  end

  private

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

  def search_data
    {
      title: composition.title,
      composers: composition&.composers&.map(&:name),
      lyricists: composition&.lyricists&.map(&:name),
      orchestra_periods: orchestra&.orchestra_periods&.map(&:name),
      orchestra: orchestra&.display_name,
      orchestra_name: orchestra&.name,
      orchestra_display_name: orchestra&.display_name,
      singer: singers.present? ? singers.map(&:display_name) : "Instrumental",
      genre: genre&.name,
      year: year,
      year_suffix: year ? year.to_s[-2..] : nil,
      popularity_score: popularity_score,
      combined: "#{composition.title} #{composition.composers.map(&:name).join(" ")}#{orchestra.display_name} #{orchestra.name} #{singers.present? ? singers.map(&:name) : "Instrumental"} #{genre.name} #{year} #{year.to_s[-2..]}"
    }
  end

  def set_year
    self.year = recorded_date&.year
  end
end

# == Schema Information
#
# Table name: recordings
#
#  id                :uuid             not null, primary key
#  recorded_date     :date
#  recording_type    :enum             default("studio"), not null
#  playbacks_count   :integer          default(0), not null
#  el_recodo_song_id :uuid
#  orchestra_id      :uuid
#  composition_id    :uuid             not null
#  genre_id          :uuid             not null
#  record_label_id   :uuid
#  time_period_id    :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  playlists_count   :integer          default(0), not null
#  tandas_count      :integer          default(0), not null
#  popularity_score  :decimal(5, 2)    default(0.0), not null
#  year              :integer
#  slug              :string
#
