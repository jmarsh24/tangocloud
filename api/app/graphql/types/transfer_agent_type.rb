module Types
  class TransferAgent < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :description, String, null: true
    field :url, String, null: true
    field :image, String, null: true
    field :logo, String, null: true
    field :audios, [Types::AudioType], null: true
    field :recordings, [Types::RecordingType], null: true
  end
end
