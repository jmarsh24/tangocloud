module Types
  class QueryType < Types::BaseObject
    field :search_recordings, RecordingType.connection_type, null: false, description: "Search for recordings." do
      argument :query, String, required: true, description: "Query to search for."
    end

    def search_recordings(query:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Recording.search_recordings(query).results
    end

    field :search_el_recodo_songs, [Types::ElRecodoSongType], null: false do
      argument :query, String, required: true, description: "Query to search for."
      argument :page, Integer, required: false, description: "Page number."
      argument :per_page, Integer, required: false, description: "Number of results per page."
    end

    def search_el_recodo_songs(query:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      ElRecodoSong.search_songs(query).results
    end

    field :who_am_i, String, null: false,
      description: "Who am I"
    def who_am_i
      "You've authenticated as #{context[:current_user].presence || "guest"}."
    end

    field :get_audio_variant, Types::AudioVariantType, null: false, description: "Get audio by ID." do
      argument :id, ID, required: true, description: "ID of the audio."
    end

    def get_audio(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Audio.find(id)
    end

    field :current_user_profile, Types::UserType, null: false, description: "Get the profile of the currently authenticated user."

    def current_user_profile
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      context[:current_user]
    end

    field :get_recording_details, Types::RecordingType, null: false, description: "Get recording details by ID." do
      argument :id, ID, required: true, description: "ID of the recording."
    end

    def get_recording_details(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Recording.find(id)
    end
  end
end
