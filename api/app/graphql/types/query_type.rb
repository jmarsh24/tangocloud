module Types
  class QueryType < Types::BaseObject
    field :recording, RecordingType, null: false, description: "Get recording by ID." do
      argument :id, ID, required: true, description: "ID of the recording."
    end

    def recording(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Recording.find(id)
    end

    field :recordings, RecordingType.connection_type, null: false, description: "Search for recordings." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def recordings(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      query = "*" if query.blank?

      Recording.search_recordings(query).results
    end

    field :el_recodo_songs, ElRecodoSongType.connection_type, null: false, description: "Search for El Recodo songs." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def el_recodo_songs(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      ElRecodoSong.search_songs(query).results
    end

    field :who_am_i, String, null: false, description: "Who am I"

    def who_am_i
      "You've authenticated as #{context[:current_user].presence || "guest"}."
    end

    field :audio_variant, AudioVariantType, null: false, description: "Get audio by ID." do
      argument :id, ID, required: true, description: "ID of the audio."
    end

    def audio_variant(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]
      AudioVariant.find(id)
    end

    field :playlists, PlaylistType.connection_type, null: false, description: "Get all playlists." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def playlists(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Playlist.search_playlists(query).results
    end

    field :playlist, PlaylistType, null: false, description: "Get playlist by ID." do
      argument :id, ID, required: true, description: "ID of the playlist."
    end

    def playlist(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Playlist.find(id)
    end

    field :composer, ComposerType, null: false, description: "Get composer by ID." do
      argument :id, ID, required: true, description: "ID of the composer."
    end

    def composer(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Composer.find(id)
    end

    field :composers, ComposerType.connection_type, null: false, description: "Get all composers." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def composers(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Composer.search_composers(query).results
    end

    field :genres, GenreType.connection_type, null: false, description: "Get all genres." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def genres(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Genre.search_genres(query).results
    end

    field :genre, GenreType, null: false, description: "Get genre by ID." do
      argument :id, ID, required: true, description: "ID of the genre."
    end

    def genre(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Genre.find(id)
    end

    field :lyricists, LyricistType.connection_type, null: false, description: "Get all lyricists." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def lyricists(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Lyricist.search_lyricists(query).results
    end

    field :lyricist, LyricistType, null: false, description: "Get lyricist by ID." do
      argument :id, ID, required: true, description: "ID of the lyricist."
    end

    def lyricist(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Lyricist.find(id)
    end

    field :orchestra, OrchestraType, null: false, description: "Get orchestra by ID." do
      argument :id, ID, required: true, description: "ID of the orchestra."
    end

    def orchestra(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Orchestra.find(id)
    end

    field :orchestras, OrchestraType.connection_type, null: false, description: "Get all orchestras." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def orchestras(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Orchestra.search_orchestras(query).results
    end

    field :singer, SingerType, null: false, description: "Get singer by ID." do
      argument :id, ID, required: true, description: "ID of the singer."
    end

    def singer(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Singer.find(id)
    end

    field :singers, SingerType.connection_type, null: false, description: "Get all singers." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def singers(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Singer.search_singers(query).results
    end

    field :period, PeriodType, null: false, description: "Get period by ID." do
      argument :id, ID, required: true, description: "ID of the period."
    end

    def period(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Period.find(id)
    end

    field :periods, PeriodType.connection_type, null: false, description: "Get all periods." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def periods(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Period.search_periods(query).results
    end

    field :user, UserType, null: false, description: "Get the profile of the currently authenticated user." do
      argument :id, ID, required: true, description: "ID of the user."
    end

    def user(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]
      context[:current_user]
    end

    field :users, UserType.connection_type, null: false, description: "Get all users." do
      argument :query, String, required: false, description: "Query to search for."
    end

    def users(query: "*")
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      User.search_users(query).results
    end

    field :user_profile, UserType, null: false, description: "Get the profile of the currently authenticated user."

    def user_profile
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      context[:current_user]
    end

    field :liked, Boolean, null: false, description: "Check if the user has liked the likeable." do
      argument :likeable_type, String, required: true, description: "Type of the likeable."
      argument :likeable_id, ID, required: true, description: "ID of the likeable."
    end

    def liked(likeable_type:, likeable_id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      likeable = likeable_type.constantize.find(likeable_id)
      likeable.likes.exists?(user: context[:current_user])
    end

    field :fetch_listen_history, resolver: Resolvers::ListenHistories::FetchListenHistory
  end
end
