# frozen_string_literal: true

class Types::GenreType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :description, String, null: true
end
