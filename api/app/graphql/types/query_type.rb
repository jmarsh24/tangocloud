module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :digital_remaster, resolver: Resolvers::DigitalRemaster
    field :audio_variant, resolver: Resolvers::AudioVariant
    field :genre, resolver: Resolvers::Genre
    field :genres, resolver: Resolvers::Genres
    field :liked_recordings, resolver: Resolvers::Recordings
    field :orchestra, resolver: Resolvers::Orchestra
    field :time_period, resolver: Resolvers::TimePeriod
    field :playlist, resolver: Resolvers::Playlist
    field :recording, resolver: Resolvers::Recording
    field :singer, resolver: Resolvers::Singer
    field :user, resolver: Resolvers::User
    field :el_recodo_songs, resolver: Resolvers::ElRecodoSongs
    field :orchestras, resolver: Resolvers::Orchestras
    field :time_periods, resolver: Resolvers::TimePeriods
    field :playlists, resolver: Resolvers::Playlists
    field :recordings, resolver: Resolvers::Recordings
    field :users, resolver: Resolvers::Users
    field :current_user, resolver: Resolvers::CurrentUser
  end
end
