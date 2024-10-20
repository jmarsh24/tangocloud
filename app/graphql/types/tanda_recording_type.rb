# app/graphql/types/tanda_recording_type.rb
module Types
  class TandaRecordingType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :position, Integer, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :tanda, null: false
    belongs_to :recording, null: false
  end
end
