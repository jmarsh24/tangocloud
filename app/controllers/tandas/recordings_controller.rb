class Tandas::RecordingsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :load

  def load
    recording = Recording.find(params[:id])
    tanda = Tanda.find(params[:tanda_id])

    authorize recording, :load?
    authorize tanda, :load?

    playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
    playback_session = PlaybackSession.find_or_create_by(user: current_user)

    playback_queue.load_tanda(tanda, start_with: recording)

    playback_session.play(reset_position: true)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:})
      end
    end
  end
end
