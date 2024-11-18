class PlaylistsController < ApplicationController
  def index
    @playlists = policy_scope(Playlist).exclude_liked.with_attached_image.limit(100)
    authorize Playlist
  end

  def show
    @playlist = policy_scope(Playlist).find(params[:id])

    recordings = PlaylistItem
      .strict_loading
      .where(item_type: "Recording", playlist_id: @playlist.id)
      .includes(
        playlist: :user,
        item: [
          :composition,
          :orchestra,
          :genre,
          :singers,
          digital_remasters: [
            audio_variants: [
              audio_file_attachment: :blob
            ],
            album: [
              album_art_attachment: :blob
            ]
          ]
        ]
      )

    tandas = PlaylistItem
      .strict_loading
      .where(item_type: "Tanda", playlist_id: @playlist.id)
      .includes(
        item: [
          :user,
          recordings: [
            :composition,
            :orchestra,
            :genre,
            :singers,
            digital_remasters: [
              audio_variants: [
                audio_file_attachment: :blob
              ],
              album: [
                album_art_attachment: :blob
              ]
            ]
          ]
        ]
      )

    @playlist_items = (recordings + tandas).sort_by(&:position)

    authorize @playlist
  end
end
