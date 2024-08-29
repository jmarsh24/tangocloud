module Resolvers
  class Recordings < BaseResolver
    type Types::RecordingType.connection_type, null: false

    def resolve
      ::Recording.all
    end
  end
end
