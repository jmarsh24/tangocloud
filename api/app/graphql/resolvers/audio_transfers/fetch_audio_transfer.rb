module Resolvers::AudioTransfers
  class FetchAudioTransfer < Resolvers::BaseResolver
    type Types::AudioTransferType, null: false

    argument :id, ID, required: true, description: "ID of the audio transfer."

    def resolve(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      AudioTransfer.find(id)
    end
  end
end
