module Types
  class TandaRecordingType < Types::BaseObject
    field :id, ID, null: false
    field :position, Integer, null: false
<<<<<<< HEAD
=======
    field :tanda_id, ID, null: false
    field :recording_id, ID, null: false
>>>>>>> main
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :tanda
    belongs_to :recording
  end
end
