module Types
  class UserHistoryType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :recording_listens, [Types::RecordingListenType], null: false
    def recording_listens
      dataloader.with(Sources::ActiveRecord, object).load_many(:recording_listens)
      object.recording_listens
    end

    belongs_to :user, null: false
  end
end
