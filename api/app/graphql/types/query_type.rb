module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :audio_variant, resolver: Resolvers::AudioVariant
    field :composers, resolver: Resolvers::Composers
    field :current_user, resolver: Resolvers::CurrentUser
    field :digital_remaster, resolver: Resolvers::DigitalRemaster
    field :el_recodo_songs, resolver: Resolvers::ElRecodoSongs
    field :genre, resolver: Resolvers::Genre
    field :genres, resolver: Resolvers::Genres
    field :liked_recordings, resolver: Resolvers::Recordings
    field :lyricists, resolver: Resolvers::Lyricists
    field :orchestra, resolver: Resolvers::Orchestra
    field :orchestras, resolver: Resolvers::Orchestras
    field :playlist, resolver: Resolvers::Playlist
    field :playlists, resolver: Resolvers::Playlists
    field :recording, resolver: Resolvers::Recording
    field :recordings, resolver: Resolvers::Recordings
    field :search_recordings, resolver: Resolvers::SearchRecordings
    field :singers, resolver: Resolvers::Singers
    field :time_period, resolver: Resolvers::TimePeriod
    field :time_periods, resolver: Resolvers::TimePeriods
    field :user, resolver: Resolvers::User
    field :users, resolver: Resolvers::Users
  end
end
