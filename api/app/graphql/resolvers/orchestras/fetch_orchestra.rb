module Resolvers::Orchestras
  class FetchOrchestra < Resolvers::BaseResolver
    type Types::OrchestraType, null: false

    argument :id, ID, required: true, description: "ID of the orchestra."

    def resolve(id:)
      Orchestra.find(id)
    end
  end
end
