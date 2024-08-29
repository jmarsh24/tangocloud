module Resolvers
  class AudioVariant < BaseResolver
    type Types::AudioVariantType, null: false

    argument :id, ID, required: true, description: "ID of the audio variant."

    def resolve(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      ::AudioVariant.find(id)
    end
  end
end
