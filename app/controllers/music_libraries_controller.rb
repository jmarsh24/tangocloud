class MusicLibrariesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:show]

  def show
    authorize :music_library, :show?

    @recordings = policy_scope(Recording).random.limit(36).includes(:composition, :orchestra, :singers, :genre, digital_remasters: [audio_variants: [audio_file_attachment: :blob], album: [album_art_attachment: :blob]])
    @playlists = policy_scope(Playlist).limit(36).with_attached_image.shuffle
    @tandas = policy_scope(Tanda).limit(36).with_attached_image.shuffle
    @orchestras = policy_scope(Orchestra).ordered_by_recordings.limit(36).with_attached_image
  end
end
