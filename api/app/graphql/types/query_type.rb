module Types
  class QueryType < Types::BaseObject
    field :fetch_audio_transfer, resolver: Resolvers::AudioTransfers::FetchAudioTransfer
    field :fetch_audio_variant, resolver: Resolvers::AudioVariants::FetchAudioVariant
    field :fetch_composer, resolver: Resolvers::Composers::FetchComposer
    field :fetch_genre, resolver: Resolvers::Genres::FetchGenre
    field :fetch_listen_history, resolver: Resolvers::ListenHistories::FetchListenHistory
    field :fetch_lyricist, resolver: Resolvers::Lyricists::FetchLyricist
    field :fetch_orchestra, resolver: Resolvers::Orchestras::FetchOrchestra
    field :fetch_period, resolver: Resolvers::Periods::FetchPeriod
    field :fetch_playlist, resolver: Resolvers::Playlists::FetchPlaylist
    field :fetch_recording, resolver: Resolvers::Recordings::FetchRecording
    field :fetch_singer, resolver: Resolvers::Singers::FetchSinger
    field :fetch_user, resolver: Resolvers::Users::FetchUser
    field :search_composers, resolver: Resolvers::Composers::SearchComposers
    field :search_el_recodo_songs, resolver: Resolvers::ElRecodoSongs::SearchElRecodoSongs
    field :search_genres, resolver: Resolvers::Genres::SearchGenres
    field :search_lyricists, resolver: Resolvers::Lyricists::SearchLyricists
    field :search_orchestras, resolver: Resolvers::Orchestras::SearchOrchestras
    field :search_periods, resolver: Resolvers::Periods::SearchPeriods
    field :search_playlists, resolver: Resolvers::Playlists::SearchPlaylists
    field :search_recordings, resolver: Resolvers::Recordings::SearchRecordings
    field :search_singers, resolver: Resolvers::Singers::SearchSingers
    field :search_users, resolver: Resolvers::Users::SearchUsers
    field :user_profile, resolver: Resolvers::Users::UserProfile
  end
end
