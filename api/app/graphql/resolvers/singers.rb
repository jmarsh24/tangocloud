module Resolvers
  class Singers < BaseResolver
    type Types::SingerType.connection_type, null: false

    argument :query, String, required: false

    def resolve(query: "*")
      ::Person.search(query,
        fields: ["name"],
        where: {singer: true},
        match: :word_start,
        misspellings: {below: 5}).results
    end
  end
end
