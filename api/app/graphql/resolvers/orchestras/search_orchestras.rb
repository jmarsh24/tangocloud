module Resolvers::Orchestras
  class SearchOrchestras < Resolvers::BaseResolver
    type Types::OrchestraType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      Orchestra.search_orchestras(query).results
    end
  end
end
