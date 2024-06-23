module Resolvers::Genres
  class SearchGenres < Resolvers::BaseResolver
    type Types::GenreType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      Genre.search(query,
        fields: ["name^5"],
        match: :word_middle,
        misspellings: {below: 5}).results
    end
  end
end
