module Resolvers
  class Recording < BaseResolver
    type Types::RecordingType, null: false

    argument :id, ID, required: true, description: "ID of the recording."

    def resolve(id:)
      ::Recording.find(id)
    end
  end
end
