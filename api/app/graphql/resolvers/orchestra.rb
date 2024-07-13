module Resolvers
  class Orchestra < BaseResolver
    type Types::OrchestraType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      check_authentication!

      ::Orchestra.find(id)
    end
  end
end
