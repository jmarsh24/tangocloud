class RecordingsController < ApplicationController
  def index
    @recordings = policy_scope(Recording).random.limit(100).strict_loading.includes(:composition, :orchestra, :singers, :genre, digital_remasters: [audio_variants: [audio_file_attachment: :blob], album: [album_art_attachment: :blob]])

    authorize Recording
  end
end
