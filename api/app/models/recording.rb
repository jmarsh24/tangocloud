# frozen_string_literal: true

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
#  record_label_id   :uuid
#  genre_id          :uuid
#  period_id         :uuid
#  recording_type    :enum             default("studio"), not null
#  slug              :string
#
class Recording < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :el_recodo_song, optional: true
  belongs_to :orchestra, optional: true
  belongs_to :singer, optional: true
  belongs_to :song, optional: true
  belongs_to :record_label, optional: true
  belongs_to :genre, optional: true
  has_one :audio_transfer, dependent: :destroy
  has_one :audio, through: :audio_transfer
  belongs_to :period, optional: true
  belongs_to :composition, optional: true

  validates :title, presence: true
  validates :recorded_date, presence: true

  enum recording_type: {studio: "studio", live: "live"}
end
