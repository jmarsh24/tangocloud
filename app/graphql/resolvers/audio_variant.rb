module Resolvers
  class AudioVariant < BaseResolver
    type Types::AudioVariantType, null: false

    argument :id, ID, required: true, description: "ID of the audio variant."

    def resolve(id:)
      ::AudioVariant.find(id)
    end
  end
end
