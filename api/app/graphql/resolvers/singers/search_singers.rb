module Resolvers::Singers
  class SearchSingers < Resolvers::BaseResolver
    type [Types::SingerType], null: false

    argument :name, String, required: true, description: "Name of the singer."

    def resolve(query: nil)
      Singer.search_singers(query)
    end
  end
end
