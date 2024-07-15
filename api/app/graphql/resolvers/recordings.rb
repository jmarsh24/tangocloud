module Resolvers
  class Recordings < BaseResolver
    type Types::RecordingType.connection_type, null: false

    def resolve
      check_authentication!

      ::Recording.all
    end
  end
end
