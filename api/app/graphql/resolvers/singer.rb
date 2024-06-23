module Resolvers
  class Singer < BaseResolver
    type Types::SingerType, null: false

    argument :id, ID, required: true, description: "ID of the singer."

    def resolve(id:)
      ::Singer.find(id)
    end
  end
end
