# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id           :uuid             not null, primary key
#  youtube_slug :string           default(""), not null
#  title        :string           default(""), not null
#  description  :string           default(""), not null
#  recording_id :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Video < ApplicationRecord
  belongs_to :recording

  validates :youtube_slug, presence: true, uniqueness: true
  validates :title, presence: true
  validates :description, presence: true
  validates :recording_id, presence: true, uniqueness: true
  validates :recording_id, uniqueness: {scope: :youtube_slug}
end
