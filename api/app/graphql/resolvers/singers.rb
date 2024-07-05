module Resolvers
  class Singers < BaseResolver
    type Types::SingerType.connection_type, null: false

    argument :query, String, required: false

    def resolve(query: "*")
      ::Singer.search(query,
        fields: ["name"],
        match: :word_start,
        misspellings: {below: 5}).results
    end
  end
end
