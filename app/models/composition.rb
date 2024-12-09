class Composition < ApplicationRecord
  searchkick word_start: [:title, :composers, :lyricists, :recording_titles, :recording_orchestras, :recording_singers, :genre],
    word_middle: [:combined, :lyrics],
    filterable: [:composer_names, :lyricist_names, :genre],
    callbacks: :async

  has_many :recordings, dependent: :destroy
  has_many :composition_lyrics, dependent: :destroy
  has_many :composition_roles, dependent: :destroy
  has_many :lyrics, through: :composition_lyrics
  has_many :composers, -> { where(composition_roles: {role: "composer"}) }, through: :composition_roles, source: :person
  has_many :lyricists, -> { where(composition_roles: {role: "lyricist"}) }, through: :composition_roles, source: :person
  has_many :digital_remasters, through: :recordings

  validates :title, presence: true

  private

  scope :search_import, -> {
    includes(
      :composers,
      :lyricists,
      :lyrics,
      recordings: [
        :orchestra,
        :genre,
        singers: []
      ]
    )
  }

  def search_data
    {
      title: title,
      composers: composers.map(&:name).join(", "),
      lyricists: lyricists.map(&:name).join(", "),
      recording_titles: recordings.map(&:title).join(", "),
      recording_orchestras: recordings.filter_map { _1.orchestra&.display_name }.join(", "),
      recording_singers: recordings.flat_map { _1.singers.map(&:display_name) }.compact.join(", "),
      genre: recordings.filter_map { _1.genre&.name }.uniq.join(", "),
      lyrics: lyrics.map(&:text).join(" "),
      combined: "#{title} #{composers.map(&:name).join(" ")} #{lyricists.map(&:name).join(" ")} #{recordings.map(&:title).join(" ")} #{recordings.map { _1.orchestra&.display_name }.join(" ")} #{recordings.flat_map { _1.singers.map(&:display_name) }.join(" ")} #{recordings.map { _1.genre&.name }.join(" ")} #{lyrics.map(&:text).join(" ")}"
    }
  end
end

# == Schema Information
#
# Table name: compositions
#
#  id         :uuid             not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
