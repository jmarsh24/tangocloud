class QueuesController < ApplicationController
  include RemoteModal
  before_action :set_queue
  skip_after_action :verify_authorized, only: [:show, :next, :previous] 

  def show
    @queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
    authorize @queue

    if @queue.queue_items.empty?
      recordings = policy_scope(Recording).limit(10)

      recordings.each do |recording|
        @queue.queue_items.build(item: recording)
      end

      @queue.save!
    end
  end

  def play
    @recording = policy_scope(Recording).find(params[:recording_id])
    authorize @recording, :play?

    queue_item = @queue.queue_items.find_by(item: @recording)
    if queue_item
      queue_item.move_to_top
    else
      @queue.queue_items.create!(item: @recording, position: 1)
    end

    @queue.reload
    render turbo_stream: turbo_stream.update("music-player", partial: "shared/music_player", locals: { recording: @recording })
  end

  def next
    current_item = @queue.queue_items.order(:position).first
    current_item.move_to_bottom if current_item.present?

    @queue.reload
    @recording = @queue.queue_items.order(:position).first&.item

    render turbo_stream: turbo_stream.update("music-player", partial: "shared/music_player", locals: { recording: @recording })
  end

  def previous
    last_item = @queue.queue_items.order(:position).last
    last_item.move_to_top if last_item.present?

    @queue.reload
    @recording = @queue.queue_items.order(:position).first&.item

    render turbo_stream: turbo_stream.update("music-player", partial: "shared/music_player", locals: { recording: @recording })
  end

  private

  def set_queue
    @queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
  end
end