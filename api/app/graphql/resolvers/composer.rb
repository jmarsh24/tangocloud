module Resolvers
  class Composer < BaseResolver
    type Types::ComposerType, null: false

    argument :id, ID, required: true, description: "ID of the composer."

    def resolve(id:)
      ::Composer.find(id)
    end
  end
end
