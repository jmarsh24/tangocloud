class TandaRecording < ApplicationRecord
  belongs_to :tanda
  belongs_to :recording

  validates :tanda, presence: true
  validates :recording, presence: true
end

# == Schema Information
#
# Table name: tanda_recordings
#
#  id           :uuid             not null, primary key
#  position     :integer          default(0), not null
#  tanda_id     :uuid             not null
#  recording_id :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
