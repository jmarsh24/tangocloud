module Types
  class OrchestraRoleType < Types::BaseObject
    field :id, ID, null: true

    has_many :orchestra_positions
  end
end
