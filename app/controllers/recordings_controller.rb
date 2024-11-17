class RecordingsController < ApplicationController
  def show
    playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
    playback_session = PlaybackSession.find_or_create_by(user: current_user)

    authorize @recording = policy_scope(Recording).find(params[:id])

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:})
      end
    end
  end
end
