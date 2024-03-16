module Types
  class TransferAgentType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :url, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :recordings, [RecordingType], null: false

    def recordings
      dataloader.with(Sources::Preload, :recordings).load(object)
      object.recordings
    end

    field :audio_variants, [AudioVariantType], null: false

    def audio_variants
      dataloader.with(Sources::Preload, :audio_variants).load(object)
      object.audio_variants
    end

    field :audio_transfers, [AudioTransferType], null: false

    def audio_transfers
      dataloader.with(Sources::Preload, :audio_transfers).load(object)
      object.audio_transfers
    end
  end
end
