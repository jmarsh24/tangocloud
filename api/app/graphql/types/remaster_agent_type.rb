module Types
  class RemasterAgentType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :url, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_many :recordings
    has_many :audio_variants
    has_many :digital_remaster
  end
end
