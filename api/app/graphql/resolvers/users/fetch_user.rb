module Resolvers::Users
  class FetchUser < Resolvers::BaseResolver
    type Types::UserType, null: false

    argument :id, ID, required: true, description: "ID of the user."

    def resolve(id:)
      User.find(id)
    end
  end
end
