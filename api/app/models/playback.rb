class Playback < ApplicationRecord
  belongs_to :user
  belongs_to :recording

  scope :most_recent, -> { order(created_at: :desc) }
end

# == Schema Information
#
# Table name: playbacks
#
#  id           :uuid             not null, primary key
#  duration     :integer          default(0), not null
#  user_id      :uuid             not null
#  recording_id :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
