class PlaylistsController < ApplicationController
  def index
    @playlists = policy_scope(Playlist).with_attached_image.limit(100)

    authorize Playlist
  end

  def show
    @playlist = policy_scope(Playlist).friendly.find(params[:id])

    authorize @playlist
  end
end
