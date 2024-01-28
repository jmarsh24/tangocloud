# frozen_string_literal: true

class Types::TandaType < Types::BaseObject
  implements Types::NodeType
  implements Types::PaginableType
  implements Types::SearchableType

  field :id, ID, null: false
  field :name, String, null: false
  field :description, String, null: true
  field :public, Boolean, null: false
  field :audio_transfer_id, Integer, null: false
  field :audio_transfer, Types::AudioTransferType, null: false
  field :user_id, Integer, null: false
  field :user, Types::UserType, null: false
  field :audio_transfer_tandas, [Types::AudioTransferTandaType], null: true
  field :audio_transfer, [Types::AudioTransferType], null: true
  field :audio, [Types::AudioType], null: true
  field :audio_transfers, [Types::AudioTransferType], null: true
end
