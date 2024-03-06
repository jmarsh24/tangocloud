module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Users::LoginUser
    field :register, mutation: Mutations::Users::RegisterUser

    field :add_like_to_recording, mutation: Mutations::Recordings::AddLikeToRecording
    field :create_listen, mutation: Mutations::ListenHistories::CreateListen
    field :remove_like_from_recording, mutation: Mutations::Recordings::RemoveLikeFromRecording
    field :remove_listen, mutation: Mutations::ListenHistories::RemoveListen
    field :reorder_playlist_items, mutation: Mutations::Playlists::ReorderPlaylistItems
  end
end
