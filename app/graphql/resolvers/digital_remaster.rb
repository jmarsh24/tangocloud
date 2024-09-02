module Resolvers
  class DigitalRemaster < BaseResolver
    type Types::DigitalRemasterType, null: false

    argument :id, ID, required: true, description: "ID of the audio transfer."

    def resolve(id:)
      ::DigitalRemaster.find(id)
    end
  end
end
