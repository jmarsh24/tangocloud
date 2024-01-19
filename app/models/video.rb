# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id           :integer          not null, primary key
#  youtube_slug :string           not null
#  title        :string           not null
#  description  :string           not null
#  recording_id :integer          not null
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
