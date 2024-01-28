# frozen_string_literal: true

class LyricistType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :description, String, null: true
  field :lyrics, [Types::LyricType], null: true
end
