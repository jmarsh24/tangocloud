module Resolvers
  class DigitalRemaster < BaseResolver
    type Types::DigitalRemasterType, null: false

    argument :id, ID, required: true, description: "ID of the audio transfer."

    def resolve(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      ::DigitalRemaster.find(id)
    end
  end
end
