

# frozen_string_literal: true

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

module Types
  class AudioTransferType < Types::BaseObject
    field :id, ID, null: false
    field :method, String, null: true
    field :external_id, String, null: true
    field :recording_date, GraphQL::Types::ISO8601Date, null: true
    field :transfer_agent_id, ID, null: true
    field :audio_id, ID, null: true
    field :recording_id, ID, null: true
    field :audio, Types::AudioType, null: true
    field :recording, Types::RecordingType, null: true
    field :transfer_agent, Types::TransferAgentType, null: true
  end
end
