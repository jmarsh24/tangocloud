# frozen_string_literal: true

module Types
  class LyricType < Types::BaseObject
    field :id, ID, null: false
    field :locale, String, null: false
    field :content, String, null: false
    field :composition_id, Integer, null: false
    field :composition, Types::CompositionType, null: false
  end
end
