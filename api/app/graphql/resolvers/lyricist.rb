module Resolvers
  class Lyricist < BaseResolver
    type Types::LyricistType, null: false

    argument :id, ID, required: true, description: "ID of the lyricist."

    def resolve(id:)
      ::Lyricist.find(id)
    end
  end
end
