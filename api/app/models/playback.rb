class Playback < ApplicationRecord
  belongs_to :listen_history
  belongs_to :recording

  delegate :user, to: :listen_history

  scope :most_recent, -> { order(created_at: :desc) }
end

# == Schema Information
#
# Table name: recording_listens
#
#  id           :uuid             not null, primary key
#  history_id   :uuid
#  recording_id :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
