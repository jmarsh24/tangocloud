# frozen_string_literal: true

module Types
  class TandaType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :public, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :tanda_recordings, [TandaRecordingType], null: false

    def tanda_recordings
      dataloader.with(Sources::Preload, :tanda_recordings).load(object)
      object.tanda_recordings
    end
  end
end
