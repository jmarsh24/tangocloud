class RecordingsController < ApplicationController
  layout "music_player"

  def index
    @recordings = policy_scope(Recording).limit(100).includes(:composition, :orchestra, :singers, :genre, digital_remasters: [audio_variants: [audio_file_attachment: :blob], album: [album_art_attachment: :blob]])

    authorize Recording
  end
end
