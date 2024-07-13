module Resolvers
  class User < BaseResolver
    type Types::UserType, null: false

    argument :id, ID, required: true, description: "ID of the user."

    def resolve(id:)
      check_authentication!

      ::User.find(id)
    end
  end
end
