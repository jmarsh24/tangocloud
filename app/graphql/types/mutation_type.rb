module Types
  class MutationType < Types::BaseObject
    field :add_playlist_recording, mutation: Mutations::Playlists::AddPlaylistRecording
    field :like_recording, mutation: Mutations::Recordings::LikeRecording
    field :unlike_recording, mutation: Mutations::Recordings::UnlikeRecording

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
