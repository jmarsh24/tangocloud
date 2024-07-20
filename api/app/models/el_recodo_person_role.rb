class ElRecodoPersonRole < ApplicationRecord
  belongs_to :el_recodo_person
  belongs_to :el_recodo_song

  validates :el_recodo_person, presence: true
  validates :role, presence: true

  ROLES = [
    "orchestra",
    "piano",
    "arranger",
    "doublebass",
    "bandoneon",
    "violin",
    "singer",
    "soloist",
    "director",
    "composer",
    "author"
  ].freeze

  validates :role, inclusion: {in: ROLES}

  alias_method :person, :el_recodo_person
  alias_method :song, :el_recodo_song

  normalizes :role, with: ->(value) { value.to_s.downcase }
end

# == Schema Information
#
# Table name: el_recodo_person_roles
#
#  id                  :uuid             not null, primary key
#  el_recodo_person_id :uuid             not null
#  el_recodo_song_id   :uuid             not null
#  role                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
