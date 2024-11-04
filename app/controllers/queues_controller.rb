class QueuesController < ApplicationController
  include RemoteModal
  before_action :set_queue
  before_action :set_playback_session
  skip_after_action :verify_authorized, only: [:show, :next, :previous, :play_recording]

  def show
    authorize @playback_queue

    @playback_session = PlaybackSession.find_or_create_by(user: current_user)
    @playback_queue.ensure_default_items

    @playback_queue_items = @playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)
  end

  def play_recording
    @recording = policy_scope(Recording).find(params[:recording_id])
    authorize @recording, :play?

    @playback_queue.play_recording(@recording)

    @playback_queue_items = @playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue:, playback_session:}),
      turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue:, playback_session:, queue_items:})
    ]
  end

  def next
    @playback_queue.next_item(@playback_session)

    @recording = @playback_queue.current_item&.item

    @playback_queue_items = @playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue: @playback_queue, playback_session: @playback_session}),
      turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue_items})
    ]
  end

  def previous
    @playback_queue.previous_item(@playback_session)

    @recording = @playback_queue.current_item&.item

    @playback_queue_items = @playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue: @playback_queue, playback_session: @playback_session}),
      turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue_items})
    ]
  end

  private

  def set_queue
    @playback_queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
  end

  def set_playback_session
    @playback_session = PlaybackSession.find_or_create_by(user: current_user)
  end
end
