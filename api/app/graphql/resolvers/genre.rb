module Resolvers
  class Genre < BaseResolver
    type Types::GenreType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      check_authentication!

      ::Genre.find(id)
    end
  end
end
