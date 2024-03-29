module Types
  class AudioVariantType < Types::BaseObject
    field :id, ID, null: false
    field :duration, Integer, null: false
    field :format, String, null: false
    field :codec, String, null: false
    field :bit_rate, Integer
    field :sample_rate, Integer
    field :channels, Integer
    field :length, Integer, null: false
    field :metadata, GraphQL::Types::JSON, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :audio_file_url, String, null: true

    def audio_file_url
      dataloader.with(Sources::Preload, audio_file_attachment: :blob).load(object)
      object.audio_file&.url
    end

    belongs_to :audio_transfer
  end
end
