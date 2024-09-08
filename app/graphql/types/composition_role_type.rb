module Types
  class CompositionRoleType < Types::BaseObject
    field :id, ID, null: false

    enum_field :role

    belongs_to :composition
    belongs_to :person, type: Types::PersonType
  end
end
