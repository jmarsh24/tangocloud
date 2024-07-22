class ElRecodoSong < ApplicationRecord
  searchkick word_start: [:title, :composer, :author, :lyrics, :orchestra, :singer], callbacks: :async

  belongs_to :el_recodo_orchestra, optional: true

  has_many :el_recodo_person_roles, dependent: :destroy
  has_many :el_recodo_people, through: :el_recodo_person_roles
  alias_method :people, :el_recodo_people
  alias_method :people_roles, :el_recodo_person_roles

  ElRecodoPersonRole::ROLES.each do |role|
    has_many :"#{role}_roles", -> { where(role:) }, class_name: "ElRecodoPersonRole", dependent: :destroy, inverse_of: :el_recodo_song
    has_many role.pluralize.to_sym, through: :"#{role}_roles", source: :el_recodo_person
  end

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
      label:,
      lyrics:,
      orchestra: el_recodo_orchestra&.name,
      singers: singers.map(&:name),
      composers: composers.map(&:name),
      authors: authors.map(&:name),
      directors: directors.map(&:name),
      soloists: soloists.map(&:name),
      people: people.map(&:name)
    }
  end

  def formatted_title
    elements = [
      title,
      el_recodo_orchestra&.name,
      singers.map(&:name).join(", "),
      date&.year,
      style
    ].reject(&:blank?)
    elements.join(" • ")
  end
end

# == Schema Information
#
# Table name: el_recodo_songs
#
#  id                     :uuid             not null, primary key
#  date                   :date             not null
#  ert_number             :integer          default(0), not null
#  title                  :string           not null
#  style                  :string
#  label                  :string
#  instrumental           :boolean          default(TRUE), not null
#  lyrics                 :text
#  lyrics_year            :integer
#  search_data            :string
#  matrix                 :string
#  disk                   :string
#  speed                  :integer
#  duration               :integer
#  synced_at              :datetime         not null
#  page_updated_at        :datetime         not null
#  el_recodo_orchestra_id :uuid
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
