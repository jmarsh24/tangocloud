class MusicLibrariesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:show]

  def show
    authorize :music_library, :show?

    @recordings = policy_scope(Recording).random.limit(128).strict_loading.includes(:composition, :orchestra, :singers, :genre, digital_remasters: [audio_variants: [audio_file_attachment: :blob], album: [album_art_attachment: :blob]])
    @playlists = policy_scope(Playlist).random.limit(64).with_attached_image
    @tandas = policy_scope(Tanda).limit(64).random.with_attached_image
    @orchestras = policy_scope(Orchestra).ordered_by_recordings.with_attached_image
  end
end
