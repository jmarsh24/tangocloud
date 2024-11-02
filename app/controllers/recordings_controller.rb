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

    query = Recording::Query.new(
      orchestra: @filters[:orchestra],
      year: @filters[:year],
      genre: @filters[:genre],
      orchestra_period: @filters[:orchestra_period],
      singer: @filters[:singer],
      items: 200
    )

    recording = Recording.find(params[:id])
    authorize recording, :play?

    all_recordings = query.results.to_a

    recording_index = all_recordings.index { |r| r.id == recording.id }

    rearranged_recordings = all_recordings.drop(recording_index) + all_recordings.take(recording_index)

    queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
    queue.update!(current_item: nil)
    queue.queue_items.delete_all

    queue_items_data = rearranged_recordings.each_with_index.map do |rec, index|
      {
        playback_queue_id: queue.id,
        item_type: "Recording",
        item_id: rec.id,
        row_order: (index + 1) * 100,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    QueueItem.insert_all(queue_items_data)
    queue.reload

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
      .rank(:row_order)
      .offset(1)
      .load

    queue.update!(current_item: queue.queue_items.rank(:row_order).first, playing: true)

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
