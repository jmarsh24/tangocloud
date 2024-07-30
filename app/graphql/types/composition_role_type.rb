module Types
  class CompositionRoleType < Types::BaseObject
    field :id, ID, null: true
    field :composition, Types::CompositionType, null: true
    field :person, Types::PersonType, null: true

    enum_field :role

    belongs_to :composition
    belongs_to :person
  end
end
