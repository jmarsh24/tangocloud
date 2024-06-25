class MoodTag < ApplicationRecord
  belongs_to :recording
  belongs_to :mood
  belongs_to :user

  validates :recording_id, presence: true
  validates :mood_id, presence: true
  validates :user_id, presence: true
  validates :recording_id, uniqueness: {scope: [:mood_id, :user_id], message: "already has this mood from this user"}
end

# == Schema Information
#
# Table name: mood_tags
#
#  id           :uuid             not null, primary key
#  recording_id :uuid             not null
#  mood_id      :uuid             not null
#  user_id      :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
