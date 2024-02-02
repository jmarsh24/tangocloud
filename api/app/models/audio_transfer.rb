class AudioTransfer < ApplicationRecord
  has_many :audio_transfers, dependent: :destroy
  has_many :audios, through: :audio_transfers
  has_many :recordings, through: :audio_transfers
  belongs_to :album_audio_transfer, dependent: :destroy
  belongs_to :transfer_agent, dependent: :destroy
  belongs_to :recording, dependent: :destroy
  belongs_to :transfer_agent

  validates :transfer_agent_id, presence: true
end

# == Schema Information
#
# Table name: audio_transfers
#
#  id                :uuid             not null, primary key
#  external_id       :string
#  transfer_agent_id :uuid
#  recording_id      :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
