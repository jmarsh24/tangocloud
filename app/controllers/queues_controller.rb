class QueuesController < ApplicationController
  include RemoteModal
  before_action :set_queue
  skip_after_action :verify_authorized, only: [:show, :next, :previous] 

  def show
    @queue = policy_scope(PlaybackQueue).find_or_create_by(user: current_user)
    @recording = policy_scope(Recording).find(params[:recording_id]) if params[:recording_id].present?
    authorize @recording if @recording.present?
    authorize @queue

    if @queue.queue_items.empty?
      recordings = policy_scope(Recording).limit(10)

      recordings.each do |recording|
        @queue.queue_items.build(item: recording)
      end

      @queue.save!
    end
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