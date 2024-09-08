module Resolvers
  class Search < BaseResolver
    type [Types::SearchResultType], null: true

    argument :query, String, required: false

    def resolve(query: "*")
      Searchkick.search(query,
        models: [
          ::Recording,
          ::Orchestra,
          ::Playlist,
          ::Genre,
          ::Tanda
        ],
        limit: 100).results
    end
  end
end
