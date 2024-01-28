# frozen_string_literal: true

class RecordingSingerType < Types::BaseObject
  field :id, ID, null: false
  field :recording_id, ID, null: false
  field :singer_id, ID, null: false
  field :singer, Types::SingerType, null: false
  field :recording, Types::RecordingType, null: false
end
