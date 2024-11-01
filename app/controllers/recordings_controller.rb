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

    @recording = query.results
      .includes(
        :composition,
        :orchestra,
        :genre,
        :singers,
        digital_remasters: [
          :album,
          audio_variants: {audio_file_attachment: :blob},
          album: {album_art_attachment: :blob}
        ]
      )
      .find_by(slug: params[:id])
    authorize @recording, :play?

    recordings = query.results.where("recordings.id >= ?", @recording.id)

    queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
    queue.update!(current_item: nil)
    queue.queue_items.delete_all

    queue_items_data = recordings.each_with_index.map do |recording, index|
      {
        playback_queue_id: queue.id,
        item_type: "Recording",
        item_id: recording.id,
        position: index + 1,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    QueueItem.insert_all(queue_items_data)
    queue.reload

    queue = PlaybackQueue.find(queue.id)
    queue_items = queue.queue_items
      .includes(
        item: [
          :composition,
          :orchestra,
          :genre,
          :singers,
          digital_remasters: [
            audio_variants: {audio_file_attachment: :blob},
            album: {album_art_attachment: :blob}
          ]
        ]
      )
      .order(:position)
      .offset(1)

    queue.update!(current_item: queue.queue_items.first, playing: true)

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
