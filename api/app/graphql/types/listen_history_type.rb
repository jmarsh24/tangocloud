module Types
  class ListenHistoryType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :listens, [Types::ListenType], null: false
    def listens
      dataloader.with(Sources::ActiveRecord, object).load_many(:listens)
      object.listens
    end

    belongs_to :user, null: false
  end
end
