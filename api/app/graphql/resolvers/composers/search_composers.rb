module Resolvers::Composers
  class SearchComposers < Resolvers::BaseResolver
    type Types::ComposerType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: nil)
      Composer.search_composers(query)
    end
  end
end
