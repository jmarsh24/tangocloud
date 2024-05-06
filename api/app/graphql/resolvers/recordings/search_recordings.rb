module Resolvers::Recordings
  class SearchRecordings < Resolvers::BaseResolver
    type Types::RecordingType.connection_type, null: false

    argument :query, String, required: false, description: "Query to search for."

    def resolve(query:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      if query.blank? || query == "*"
        Recording.includes(
          :orchestra,
          :recording_singers,
          :singers,
          :composition,
          :genre,
          :period,
          :lyrics,
          :audio_variants,
          audio_transfers: [album: {album_art_attachment: :blob}]
        ).order(playbacks_count: :desc)
      else
        Recording.search_recordings(query || "*").results
      end
    end
  end
end
