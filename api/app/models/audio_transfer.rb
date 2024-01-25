# frozen_string_literal: true

# == Schema Information
#
# Table name: audio_transfers
#
#  id                :uuid             not null, primary key
#  method            :string           not null
#  external_id       :string
#  recording_date    :date
#  transfer_agent_id :uuid
#  audio_id          :uuid
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class AudioTransfer < ApplicationRecord
  belongs_to :audio
  belongs_to :transfer_agent

  validates :method, presence: true
  validates :string, presence: true
  validates :url, presence: true
  validates :transfer_agent_id, presence: true
  validates :audio_id, presence: true
end
