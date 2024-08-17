module Types
  class OrchestraRoleType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true

    has_many :orchestra_positions
    has_many :orchestras
  end
end
