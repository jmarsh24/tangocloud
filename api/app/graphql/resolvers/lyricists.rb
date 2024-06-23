module Resolvers
  class Lyricists < BaseResolver
    type Types::LyricistType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      ::Lyricist.search(query,
        fields: ["name^5"],
        match: :word_start,
        misspellings: {below: 5}).results
    end
  end
end
