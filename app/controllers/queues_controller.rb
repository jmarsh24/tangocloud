class QueuesController < ApplicationController
  include RemoteModal
  before_action :set_queue
  skip_after_action :verify_authorized, only: [:show, :next, :previous, :play, :pause, :play_recording]

  def show
    authorize @queue

    @queue.ensure_default_items

    @queue_items = @queue.queue_items.including_item_associations.rank(:row_order).offset(1)
  end

  def play_recording
    @recording = policy_scope(Recording).find(params[:recording_id])
    authorize @recording, :play?

    @queue.play_recording(@recording)

    @queue_items = @queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {recording: @queue.current_item&.item, queue: @queue}),
      turbo_stream.update("queue", partial: "queues/queue", locals: {queue: @queue, queue_items: @queue_items})
    ]
  end

  def next
    @queue.next_item

    @recording = @queue.current_item&.item

    @queue_items = @queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {recording: @recording, queue: @queue}),
      turbo_stream.update("queue", partial: "queues/queue", locals: {queue: @queue, queue_items: @queue_items})
    ]
  end

  def previous
    @queue.previous_item

    @recording = @queue.current_item&.item

    @queue_items = @queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {recording: @recording, queue: @queue}),
      turbo_stream.update("queue", partial: "queues/queue", locals: {queue: @queue, queue_items: @queue_items})
    ]
  end

  def play
    @queue.update!(playing: true)
    head :ok
  end

  def pause
    @queue.update!(playing: false)
    head :ok
  end

  private

  def set_queue
    @queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
  end
end
