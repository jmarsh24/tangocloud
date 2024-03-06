module Resolvers::Composers
  class SearchComposers < Resolvers::BaseResolver
    type Types::ComposerType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      Composer.search_composers(query).results
    end
  end
end
