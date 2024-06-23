module Resolvers
  class Composers < BaseResolver
    type Types::ComposerType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      ::Composer.search(query,
        match: :word_start,
        misspellings: {below: 5}).results
    end
  end
end
