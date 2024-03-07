module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Users::LoginUser
    field :register, mutation: Mutations::Users::RegisterUser

    field :add_like_to_recording, mutation: Mutations::Recordings::AddLikeToRecording
    field :add_playlist_recording, mutation: Mutations::Playlists::AddPlaylistRecording
    field :create_listen, mutation: Mutations::ListenHistories::CreateListen
    field :create_playlist, mutation: Mutations::Playlists::CreatePlaylist
    field :delete_playlist, mutation: Mutations::Playlists::DeletePlaylist
    field :remove_like_from_recording, mutation: Mutations::Recordings::RemoveLikeFromRecording
    field :remove_listen, mutation: Mutations::ListenHistories::RemoveListen
    field :remove_playlist_item, mutation: Mutations::Playlists::RemovePlaylistItem
    field :reorder_playlist_items, mutation: Mutations::Playlists::ReorderPlaylistItems
    field :update_playlist, mutation: Mutations::Playlists::UpdatePlaylist
    field :update_user, mutation: Mutations::Users::UpdateUser
  end
end
