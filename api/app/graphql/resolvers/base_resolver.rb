module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    def resolve_audio(id:)
      audio = Audio.find(id)
      url = generate_signed_url(audio)
      {
        id: audio.id,
        url:
      }
    end

    def generate_signed_url(audio)
      Rails.application.routes.url_helpers.rails_blob_path(audio.file, disposition: "attachment")
    end
  end
end
