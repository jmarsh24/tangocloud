class AudioTransfer < ApplicationRecord
  has_many :audios, dependent: :destroy
  belongs_to :transfer_agent, dependent: :destroy
  belongs_to :recording, dependent: :destroy
  belongs_to :audio
  belongs_to :transfer_agent

  validates :method, presence: true
  validates :string, presence: true
  validates :url, presence: true
  validates :transfer_agent_id, presence: true
  validates :audio_id, presence: true
end

# == Schema Information
#
# Table name: audio_transfers
#
#  id                :uuid             not null, primary key
#  external_id       :string
#  transfer_agent_id :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  recording_id      :uuid
#
