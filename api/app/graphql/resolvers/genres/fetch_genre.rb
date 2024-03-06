module Resolvers::Genres
  class FetchGenre < Resolvers::BaseResolver
    type Types::GenreType, null: false

    argument :id, ID, required: true, description: "ID of the genre."

    def resolve(id:)
      Genre.find(id)
    end
  end
end
