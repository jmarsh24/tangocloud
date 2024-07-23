class DigitalRemaster < ApplicationRecord
  belongs_to :album
  belongs_to :remaster_agent, optional: true
  belongs_to :recording
  belongs_to :audio_file

  has_many :audio_variants, dependent: :destroy
  has_one :waveform, dependent: :destroy

  validates :duration, presence: true, numericality: {greater_than_or_equal_to: 0}
end

# == Schema Information
#
# Table name: digital_remasters
#
#  id                :uuid             not null, primary key
#  duration          :integer          default(0), not null
#  bpm               :integer
#  external_id       :string
#  replay_gain       :decimal(5, 2)
#  peak_value        :decimal(8, 6)
#  tango_cloud_id    :integer          not null
#  album_id          :uuid             not null
#  remaster_agent_id :uuid
#  recording_id      :uuid             not null
#  audio_file_id     :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
