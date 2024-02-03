class RecordingSinger < ApplicationRecord
  belongs_to :recording
  belongs_to :singer

  validates :recording_id, presence: true
  validates :singer_id, presence: true
end

# == Schema Information
#
# Table name: recording_singers
#
#  id           :uuid             not null, primary key
#  recording_id :uuid             not null
#  singer_id    :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
