class PlaybacksController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:play, :pause, :next, :previous, :update_volume, :mute, :unmute]

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
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue: @playback_queue, playback_session: @playback_session}, method: "morph"),
      turbo_stream.update("sidebar-queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue_items}, method: "morph"),
      turbo_stream.update("modal-queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue_items}, method: "morph"),
      turbo_stream.update("modal-now-playing", partial: "players/player", locals: {playback_session: @playback_session, recording: @recording}, method: "morph")
    ]
  end

  def previous
    @playback_queue.previous_item

    @recording = @playback_queue.current_item&.item

    @playback_queue_items = @playback_queue.queue_items.including_item_associations.rank(:row_order).offset(1)

    @playback_session.play(reset_position: true)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue: @playback_queue, playback_session: @playback_session}, method: "morph"),
      turbo_stream.update("sidebar-queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue_items}, method: "morph"),
      turbo_stream.update("modal-queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue_items}, method: "morph"),
      turbo_stream.update("modal-now-playing", partial: "players/player", locals: {playback_session: @playback_session, recording: @recording}, method: "morph")
    ]
  end

  def update_volume
    @playback_session.update!(volume: params[:volume].to_i)
    head :ok
  end

  def mute
    @playback_session.update!(muted: true)
    render turbo_stream: turbo_stream.update("mute-button", partial: "shared/mute_button", locals: {playback_session: @playback_session}, method: :morph)
  end

  def unmute
    @playback_session.update!(muted: false)
    render turbo_stream: turbo_stream.update("mute-button", partial: "shared/mute_button", locals: {playback_session: @playback_session}, method: :morph)
  end
end
