# == Schema Information
#
# Table name: recordings
#
#  id                :uuid             not null, primary key
#  title             :string           not null
#  bpm               :integer
#  release_date      :date
#  recorded_date     :date
#  el_recodo_song_id :uuid
#  orchestra_id      :uuid
#  singer_id         :uuid
#  composition_id    :uuid
#  label_id          :uuid
#  genre_id          :uuid
#  period_id         :uuid
#  type              :enum             default("studio"), not null
#
class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :el_recodo_song, optional: true
  belongs_to :orchestra, optional: true
  belongs_to :singer, optional: true
  belongs_to :song, optional: true
  belongs_to :label, optional: true
  belongs_to :genre, optional: true

  validates :title, presence: true
  validates :bpm, presence: true
  validates :type, presence: true
  validates :release_date, presence: true
  validates :recorded_date, presence: true
  enum type: {studio: "studio", live: "live"}
end
