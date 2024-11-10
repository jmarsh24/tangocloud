class LibrariesController < ApplicationController
  def show
    @playlists = policy_scope(Playlist).all

    authorize Playlist, :index?
  end
end
