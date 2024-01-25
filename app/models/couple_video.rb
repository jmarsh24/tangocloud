# frozen_string_literal: true

# == Schema Information
#
# Table name: couple_videos
#
#  id        :uuid             not null, primary key
#  couple_id :uuid             not null
#  video_id  :uuid             not null
#
class CoupleVideo < ApplicationRecord
  belongs_to :couple
  belongs_to :video

  validates :couple_id, presence: true, uniqueness: {scope: :video_id}
  validates :video_id, presence: true, uniqueness: {scope: :couple_id}
end
