class LibrariesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  skip_after_action :verify_policy_scoped, only: [:show]
  skip_after_action :verify_authorized, only: [:show]
  
  def show
    @playlists = Playlist.all

    authorize Playlist, :index?
  end
end
