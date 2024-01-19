# frozen_string_literal: true

# == Schema Information
#
# Table name: recording_singers
#
#  id           :integer          not null, primary key
#  recording_id :integer          not null
#  singer_id    :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class RecordingSinger < ApplicationRecord
  belongs_to :recording
  belongs_to :singer

  validates :recording_id, presence: true
  validates :singer_id, presence: true

  def self.create_from_recording(recording)
    recording_singer = RecordingSinger.new(
      recording_id: recording.id,
      singer_id: recording.singer_id
    )
    recording_singer.save!
    recording_singer
  end
end
