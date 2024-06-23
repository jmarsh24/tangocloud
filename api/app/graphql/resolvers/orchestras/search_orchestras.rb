module Resolvers::Orchestras
  class SearchOrchestras < Resolvers::BaseResolver
    type Types::OrchestraType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      Orchestra.search(query,
        fields: ["name^5"],
        match: :word_middle,
        misspellings: {below: 5}).results
    end
  end
end
