class PlaybacksController < ApplicationController
  before_action :set_playback_session
  before_action :set_playback_queue
  skip_after_action :verify_authorized, only: [:play, :pause, :next, :previous]
  skip_after_action :verify_policy_scoped, only: [:play, :pause, :next, :previous]

  def play
    @playback_session.update!(playing: true)
    head :ok
  end

  def pause
    @playback_session.update!(playing: false)
    head :ok
  end

  def next
    @playback_queue.next_item

    @recording = @playback_queue.current_item&.item

    @playback_queue_items = @playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    @playback_session.play(reset_position: true)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue: @playback_queue, playback_session: @playback_session}),
      turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue_items}),
      turbo_stream.update("player", partial: "recordings/player", locals: {playback_queue: @playback_queue, playback_session: @playback_session, recording: @recording})
    ]
  end

  def previous
    @playback_queue.previous_item

    @recording = @playback_queue.current_item&.item

    @playback_queue_items = @playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    @playback_session.play(reset_position: true)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue: @playback_queue, playback_session: @playback_session}),
      turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue_items}),
      turbo_stream.update("player", partial: "recordings/player", locals: {playback_queue: @playback_queue, playback_session: @playback_session, recording: @recording})
    ]
  end

  private

  def set_playback_session
    @playback_session = PlaybackSession.find_or_create_by(user: current_user)
  end

  def set_playback_queue
    @playback_queue = PlaybackQueue.find_or_create_by(user: current_user)
  end
end
