module Types
  class AudioTransferType < Types::BaseObject
    field :id, ID, null: true
    field :external_id, String, null: true
    field :position, Integer, null: true
    field :album_id, ID, null: true
    field :transfer_agent_id, ID, null: true
    field :recording_id, ID, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true
  end
end
