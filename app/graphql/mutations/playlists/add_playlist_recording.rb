module Mutations::Playlists
  class AddPlaylistRecording < Mutations::BaseMutation
    argument :playlist_id, ID, required: true
    argument :recording_id, ID, required: true

    field :errors, [String], null: false
    field :playlist_item, Types::PlaylistItemType, null: true

    def resolve(playlist_id:, recording_id:)
      playlist = current_user.playlists.find_by(id: playlist_id)
      return {playlist_item: nil, errors: ["Playlist not found"]} if playlist.nil?

      recording = Recording.find_by(id: recording_id)
      return {playlist_item: nil, errors: ["Recording not found"]} if recording.nil?

      playlist_item = playlist.playlist_items.build(item: recording)
      playlist_item.position = playlist.playlist_items.maximum(:position).to_i + 1

      if playlist_item.save
        {playlist_item:, errors: []}
      else
        {playlist_item: nil, errors: playlist_item.errors.full_messages}
      end
    end
  end
end
