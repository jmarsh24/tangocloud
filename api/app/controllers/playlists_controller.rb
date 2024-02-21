class PlaylistsController < ApplicationController
  def new
    authorize Playlist
  end

  def create
    authorize Playlist

    params.require(:playlist).permit(playlist_file: []).tap do |whitelisted|
      whitelisted[:playlist_file].each do |uploaded_file|
        next if uploaded_file.blank?

        file = File.open(uploaded_file.tempfile)
        title = uploaded_file.original_filename.split(".").first
        Import::Playlist::PlaylistImporter.new(file,
          user: Current.user,
          title:).import
      end
    end
  end
end
