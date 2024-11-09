class Searches::RecordingsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :load

  def load
    recording = Recording.find(params[:id])
    authorize recording, :load?

    playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
    playback_session = PlaybackSession.find_or_create_by(user: current_user)

    playback_queue.play_recording(recording)

    playback_session.play(reset_position: true)

    queue_items = playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:}),
          turbo_stream.update("sidebar", partial: "sidebars/show", locals: {playback_queue:, queue_items:, playback_session:})
        ]
      end
    end
  end
end
