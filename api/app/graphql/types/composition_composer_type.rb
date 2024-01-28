# frozen_string_literal: true

class CompositionComposerType < Types::BaseObject
  field :id, ID, null: false
  field :composition_id, ID, null: false
  field :composer_id, ID, null: false
  field :composer, Types::ComposerType, null: false
  field :composition, Types::CompositionType, null: false
end
