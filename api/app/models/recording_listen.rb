class RecordingListen < ApplicationRecord
  belongs_to :user_history
  belongs_to :recording
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
