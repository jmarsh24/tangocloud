# == Schema Information
#
# Table name: audio_transfers
#
#  id                :uuid             not null, primary key
#  method            :string
#  external_id       :string
#  recording_date    :date
#  transfer_agent_id :uuid
#  audio_id          :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  recording_id      :uuid
#
class AudioTransfer < ApplicationRecord
  belongs_to :audio, dependent: :destroy
  belongs_to :transfer_agent, dependent: :destroy
  belongs_to :recording, optional: true

  validates :method, presence: true
  validates :transfer_agent_id, presence: true
  validates :audio_id, presence: true
end
