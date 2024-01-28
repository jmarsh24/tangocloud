# frozen_string_literal: true

class LabelType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :description, String, null: true
  field :recordings, [Types::RecordingType], null: true
end
