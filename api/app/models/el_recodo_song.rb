# == Schema Information
#
# Table name: el_recodo_songs
#
#  id              :uuid             not null, primary key
#  date            :date             not null
#  ert_number      :integer          default(0), not null
#  title           :string           not null
#  style           :string
#  label           :string
#  lyrics          :text
#  lyrics_year     :integer
#  search_data     :string
#  matrix          :string
#  disk            :string
#  duration        :integer
#  synced_at       :datetime         not null
#  page_updated_at :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class ElRecodoSong < ApplicationRecord
  searchkick word_start: [:title, :composer, :author, :lyrics, :orchestra, :singer], callbacks: :async

  has_many :el_recodo_person_roles, dependent: :destroy
  has_many :el_recodo_people, through: :el_recodo_person_roles
  alias_attribute :people, :el_recodo_people
  alias_attribute :people_roles, :el_recodo_person_roles

  has_one :orchestra_roles, -> { where(role: "orchestra") }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
  has_one :orchestra, through: :orchestra_roles, source: :el_recodo_person

  has_many :lyricist_roles, -> { where(role: "lyricist") }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
  has_many :lyricists, through: :lyricist_roles, source: :el_recodo_person

  has_many :pianist_roles, -> { where(role: "piano") }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
  has_many :pianists, through: :pianist_roles, source: :el_recodo_person

  has_many :arranger_roles, -> { where(role: "arranger") }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
  has_many :arrangers, through: :arranger_roles, source: :el_recodo_person

  has_many :doublebassist_roles, -> { where(role: "doublebass") }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
  has_many :doublebassists, through: :doublebassist_roles, source: :el_recodo_person

  has_many :bandoneonist_roles, -> { where(role: "bandoneon") }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
  has_many :bandoneonists, through: :bandoneonist_roles, source: :el_recodo_person

  has_many :violinist_roles, -> { where(role: "violin") }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
  has_many :violinists, through: :violinist_roles, source: :el_recodo_person

  has_many :singer_roles, -> { where(role: "singer") }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
  has_many :singers, through: :singer_roles, source: :el_recodo_person
  has_one :recording, dependent: :nullify

  validates :date, presence: true
  validates :ert_number, presence: true, uniqueness: true
  validates :title, presence: true
  validates :page_updated_at, presence: true

  def search_data
    {
      date:,
      ert_number:,
      title:,
      style:,
      orchestra:,
      singer:,
      composer:,
      author:,
      label:,
      lyrics:,
      soloist:,
      director:
    }
  end
end

# == Schema Information
#
# Table name: el_recodo_songs
#
#  id                   :uuid             not null, primary key
#  date                 :date             not null
#  ert_number           :integer          default(0), not null
#  music_id             :integer          default(0), not null
#  title                :string           not null
#  style                :string
#  orchestra            :string
#  singer               :string
#  soloist              :string
#  director             :string
#  composer             :string
#  author               :string
#  label                :string
#  lyrics               :text
#  normalized_title     :string
#  normalized_orchestra :string
#  normalized_singer    :string
#  normalized_composer  :string
#  normalized_author    :string
#  search_data          :string
#  synced_at            :datetime         not null
#  page_updated_at      :datetime         not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
