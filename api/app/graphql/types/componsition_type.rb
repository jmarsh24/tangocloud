# frozen_string_literal: true

class CompositionType < Types::BaseObject
  implements Types::NodeType
  field :id, ID, null: false
  field :name, String, null: false
  field :description, String, null: true
  field :lyricist, Types::LyricistType, null: true
  field :label, Types::LabelType, null: true
  field :recordings, [Types::RecordingType], null: true
end
