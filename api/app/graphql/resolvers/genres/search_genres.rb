module Resolvers::Genres
  class SearchGenres < Resolvers::BaseResolver
    type Types::GenreType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      Genre.search_genres(query).results
    end
  end
end
