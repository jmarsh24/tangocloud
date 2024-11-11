class Orchestras::RecordingsController < ApplicationController
  def load
    @filters = params.permit(:year, :genre, :orchestra_period, :singer).to_h.compact_blank

    query = Recording::Query.new(@filters.merge(orchestra: params[:orchestra_id], items: 200))

    recording = Recording.find(params[:id])
    authorize recording, :play?
    all_recordings = query.results.to_a

    playback_queue = policy_scope(PlaybackQueue).find_or_create_by!(user: current_user)
    playback_session = PlaybackSession.find_or_create_by!(user: current_user)

    playback_queue.load_recordings(all_recordings, start_with: recording)

    playback_session.play(reset_position: true)

    queue_items = playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:}, method: "morph"),
          turbo_stream.update("sidebar", partial: "sidebars/show", locals: {playback_queue:, queue_items:, playback_session:}, method: "morph")
        ]
      end
    end
  end
end
