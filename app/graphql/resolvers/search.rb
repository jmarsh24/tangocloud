module Resolvers
  class Search < BaseResolver
    type [Types::SearchResultType], null: true

    argument :query, String, required: false

    def resolve(query: "*")
      Searchkick.search(
        query,
        models: [
          ::Recording,
          ::Orchestra,
          ::Playlist,
          ::Genre,
          ::Tanda
        ],
        indices_boost: {::Orchestra => 4, ::Recording => 1},
        limit: 100
      ).results
    end
  end
end
