class TandaRecording < ApplicationRecord
  belongs_to :tanda
  belongs_to :recording

  acts_as_list scope: :tanda
end

# == Schema Information
#
# Table name: tanda_recordings
#
#  id           :uuid             not null, primary key
#  tanda_id     :uuid             not null
#  recording_id :uuid             not null
#  position     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
