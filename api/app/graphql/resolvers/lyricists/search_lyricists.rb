module Resolvers::Lyricists
  class SearchLyricists < Resolvers::BaseResolver
    type Types::LyricistType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      Lyricist.search_lyricists(query).results
    end
  end
end
