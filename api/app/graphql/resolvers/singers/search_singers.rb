module Resolvers::Singers
  class SearchSingers < Resolvers::BaseResolver
    type Types::SingerType.connection_type, null: false

    argument :query, String, required: false, description: "Name of the singer."

    def resolve(query: "*")
      Singer.search_singers(query).results
    end
  end
end
