# frozen_string_literal: true

# == Schema Information
#
# Table name: recordings
#
#  id             :integer          not null, primary key
#  title          :string           not null
#  bpm            :integer
#  type           :integer          default("studio"), not null
#  release_date   :date
#  recorded_date  :date
#  tangotube_slug :string
#  orchestra_id   :integer
#  singer_id      :integer
#  composition_id :integer
#  label_id       :integer
#  genre_id       :integer
#  period_id      :integer
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
  enum type: {studio: 0, live: 1}
end
