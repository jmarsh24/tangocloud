class Playlists::RecordingsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :load

  def load
    recording = Recording.find(params[:id])
    playlist = Playlist.find(params[:playlist_id])
    authorize playlist, :load?
    authorize recording, :load?

    playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
    playback_session = PlaybackSession.find_or_create_by(user: current_user)

    if playback_queue.current_item&.item == recording
      playback_session.play(reset_position: false)

      respond_to do |format|
        format.turbo_stream { head :ok }
      end
    else
      playback_queue.load_playlist(playlist, start_with: recording)
      playback_session.play(reset_position: true)

      queue_items = playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:}, method: "morph"),
            turbo_stream.update("sidebar-queue", partial: "queues/queue", locals: {playback_queue:, playback_session:, queue_items:}, method: "morph")
          ]
        end
      end
    end
  end
end
