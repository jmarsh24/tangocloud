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
<<<<<<< HEAD
    field :audio_file_url, String, null: false
    field :audio_variant_url, String, null: false
    field :audio_file, Types::FileType, null: false
    def audio_file
      object.audio_file.presence
    end
=======
    field :audio_transfer_id, ID, null: false
    field :audio_file_url, String, null: false
>>>>>>> main
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :audio_transfer
  end
end
