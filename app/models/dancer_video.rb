# frozen_string_literal: true

# == Schema Information
#
# Table name: dancer_videos
#
#  id        :integer          not null, primary key
#  dancer_id :integer          not null
#  video_id  :integer          not null
#
class DancerVideo < ApplicationRecord
  belongs_to :dancer
  belongs_to :video

  validates :dancer_id, presence: true
  validates :video_id, presence: true
  validates :dancer_id, uniqueness: {scope: :video_id}
end
