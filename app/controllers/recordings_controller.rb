class RecordingsController < ApplicationController
  def show
    @recording = policy_scope(Recording)
      .with_associations
      .includes(composition: {composition_lyrics: :lyric})
      .friendly.find(params[:id])
    authorize @recording
  end

  def load_into_queue
    @filters = params.permit(:year, :genre, :orchestra, :orchestra_period, :singer).to_h

    query = Recording::Query.new(
      orchestra: @filters[:orchestra],
      year: @filters[:year],
      genre: @filters[:genre],
      orchestra_period: @filters[:orchestra_period],
      singer: @filters[:singer],
      items: 200
    )

    @recording = query.results.find_by(slug: params[:id])
    authorize @recording, :play?

    recordings = query.results.where("recordings.id >= ?", @recording.id)

    queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
    queue.update!(current_item: nil)
    queue.queue_items.destroy_all
    recordings.each_with_index do |recording, index|
      queue.queue_items.create!(item: recording, position: index + 1)
    end

    queue.update!(current_item: queue.queue_items.first, playing: true)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {recording: queue.current_item&.item, queue:}),
          turbo_stream.update("queue", partial: "queues/queue", locals: {queue:})
        ]
      }
    end
  end
end
