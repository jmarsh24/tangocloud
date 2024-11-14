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

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:}, method: "morph"),
      turbo_stream.update("sidebar-queue", partial: "queues/queue", locals: {playback_queue:, playback_session:, queue_items:}, method: "morph")
    ]
  end
end
