module Resolvers
  class Composers < BaseResolver
    type Types::ComposerType.connection_type, null: false

    argument :query, String, required: false

    def resolve(query: "*")
      ::Person.search(query,
        match: :word_start,
        where: {composition_roles: "composer"},
        misspellings: {below: 5}).results
    end
  end
end
