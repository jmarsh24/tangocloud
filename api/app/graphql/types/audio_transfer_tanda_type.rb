# frozen_string_literal: true

class Types::AudioTransferTandaType < Types::BaseObject
  implements Types::NodeType

  field :name, String, null: false
  field :description, String, null: true
  field :public, Boolean, null: false
  field :audio_transfer_id, String, null: false
  field :user_id, String, null: false
  field :audio_transfer, Types::AudioTransferType, null: false
  field :user, Types::UserType, null: false
  field :audio, [Types::AudioType], null: true
  field :audio_transfers, [Types::AudioTransferType], null: true
end
