class RecordingsController < ApplicationController
  def show
    @recording = policy_scope(Recording)
      .with_associations
      .includes(composition: {composition_lyrics: :lyric})
      .friendly.find(params[:id])
    authorize @recording
  end

  def load_into_queue
    @filters = params.permit(:year, :genre, :orchestra, :orchestra_period, :singer).to_h.compact_blank

    query = Recording::Query.new(@filters.merge(items: 200))

    recording = Recording.find(params[:id])
    authorize recording, :play?

    all_recordings = query.results.to_a

    queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)

    queue.load_recordings(all_recordings, start_with: recording)

    queue_items = queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {recording: queue.current_item&.item, queue: queue}),
          turbo_stream.update("queue", partial: "queues/queue", locals: {queue: queue, queue_items: queue_items})
        ]
      }
    end
  end
end
