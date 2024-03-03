module Resolvers::Orchestras
  class SearchOrchestras < Resolvers::BaseResolver
    type Types::OrchestraType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: nil)
      Orchestra.search_orchestras(query)
    end
  end
end
