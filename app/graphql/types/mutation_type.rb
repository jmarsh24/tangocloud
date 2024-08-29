module Types
  class MutationType < Types::BaseObject
    field :add_like_to_recording, mutation: Mutations::Recordings::AddLikeToRecording
    field :add_playlist_recording, mutation: Mutations::Playlists::AddPlaylistRecording
    field :remove_like_from_recording, mutation: Mutations::Recordings::RemoveLikeFromRecording

    field :change_playlist_item_position, mutation: Mutations::Playlists::ChangePlaylistItemPosition

    field :create_playback, mutation: Mutations::Playbacks::CreatePlayback
    field :remove_playback, mutation: Mutations::Playbacks::RemovePlayback

    field :create_playlist, mutation: Mutations::Playlists::CreatePlaylist
    field :delete_playlist, mutation: Mutations::Playlists::DeletePlaylist
    field :remove_playlist_item, mutation: Mutations::Playlists::RemovePlaylistItem
    field :update_playlist, mutation: Mutations::Playlists::UpdatePlaylist

    field :update_user, mutation: Mutations::Users::Update
  end
end
