module Types
  class CompositionTypeEnum < Types::BaseEnum
    value "composer"
    value "lyricist"
  end

  class CompositionRoleType < Types::BaseObject
    field :id, ID, null: true
    field :role, CompositionTypeEnum, null: true

    belongs_to :composition
    belongs_to :person
  end
end
