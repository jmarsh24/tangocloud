module Resolvers
  class Lyricists < BaseResolver
    type Types::LyricistType.connection_type, null: false

    argument :query, String, required: false

    def resolve(query: "*")
      ::Person.search(query,
        match: :word_start,
        where: {composition_roles: "lyricist"},
        misspellings: {below: 5}).results
    end
  end
end
