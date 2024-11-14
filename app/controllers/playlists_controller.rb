class PlaylistsController < ApplicationController
  include RemoteModal
  skip_after_action :verify_policy_scoped, only: [:new, :create]
  skip_before_action :authenticate_user!, only: [:new]

  allowed_remote_modal_actions :add_to, :new

  def new
    authorize @playlist = Playlist.new
  end

  def index
    @playlists = policy_scope(Playlist).with_attached_image.limit(100)
    authorize Playlist
  end

  def create
    authorize @playlist = Playlist.new(user: current_user)
    if @playlist.update!(playlist_params)
      redirect_to @playlist
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @playlist = policy_scope(Playlist).friendly.find(params[:id])

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

  def add_to
    @playlist = policy_scope(Playlist).friendly.find(params[:id])
    authorize @playlist
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :subtitle, :description, :image)
  end
end
