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
class AudioTransfer < ApplicationRecord
  has_many :audios, dependent: :destroy
  belongs_to :transfer_agent, dependent: :destroy
  belongs_to :recording, dependent: :destroy
end
