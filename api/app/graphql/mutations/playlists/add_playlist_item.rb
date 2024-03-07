module Mutations::Playlists
  class AddPlaylistItem < Mutations::BaseMutation
    argument :playlist_id, ID, required: true
    argument :playable_id, ID, required: true
    argument :playable_type, String, required: true

    field :playlist_item, Types::PlaylistItemType, null: true
    field :errors, [String], null: false

    def resolve(playlist_id:, playable_id:, playable_type:)
      playlist = Playlist.find_by(id: playlist_id)
      return {playlist_item: nil, errors: ["Playlist not found"]} if playlist.nil?

      playable = playable_type.constantize.find_by(id: playable_id)
      return {playlist_item: nil, errors: ["Playable item not found"]} if playable.nil?

      playlist_item = playlist.playlist_items.build(playable:)
      playlist_item.position = playlist.playlist_items.maximum(:position).to_i + 1

      if playlist_item.save
        {playlist_item:, errors: []}
      else
        {playlist_item: nil, errors: playlist_item.errors.full_messages}
      end
    end
  end
end
