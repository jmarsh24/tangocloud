class QueuesController < ApplicationController
  include RemoteModal
  before_action :set_queue
  skip_after_action :verify_authorized, only: [:show, :next, :previous, :play, :pause, :play_recording]

  def show
    @queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
    authorize @queue

    if @queue.queue_items.empty?
      recordings = policy_scope(Recording).limit(10)
      recordings.each { |recording| @queue.queue_items.build(item: recording) }
      @queue.save!
    end
  end

  def play_recording
    @recording = policy_scope(Recording).find(params[:recording_id])
    authorize @recording, :play?

    queue_item = @queue.queue_items.find_by(item: @recording)
    if queue_item
      queue_item.move_to_top
    else
      queue_item = @queue.queue_items.create!(item: @recording, position: 1)
    end

    @queue.update!(current_item: queue_item, playing: true)

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: { recording: @recording }),
      turbo_stream.update("queue", partial: "queues/queue", locals: { queue: @queue })
    ]
  end

  def next
    current_item = @queue.queue_items.order(:position).first
    current_item.move_to_bottom if current_item.present?

    @queue.reload
    new_current_item = @queue.queue_items.order(:position).first
    @queue.update!(current_item: new_current_item)

    @recording = new_current_item&.item

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: { recording: @recording, queue: @queue }),
      turbo_stream.update("queue", partial: "queues/queue", locals: { queue: @queue })
    ]
  end

  def previous
    last_item = @queue.queue_items.order(:position).last
    last_item.move_to_top if last_item.present?

    @queue.reload
    new_current_item = @queue.queue_items.order(:position).first
    @queue.update!(current_item: new_current_item)

    @recording = new_current_item&.item

    render turbo_stream: [
      turbo_stream.update("music-player", partial: "shared/music_player", locals: { recording: @recording, queue: @queue }),
      turbo_stream.update("queue", partial: "queues/queue", locals: { queue: @queue })
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