module Types
  class CompositionTypeEnum < Types::BaseEnum
    value "composer"
    value "lyricist"
  end

  class CompositionRoleType < Types::BaseObject
    field :id, ID, null: true
    field :role, CompositionTypeEnum, null: true
    field :composition, Types::CompositionType, null: true
    field :person, Types::PersonType, null: true
  end
end
