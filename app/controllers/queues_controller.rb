class QueuesController < ApplicationController
  include RemoteModal

  respond_with_remote_modal only: [:show]

  before_action :set_recording, only: [:add, :select, :remove]
  skip_after_action :verify_authorized, only: [:show]

  def show
    @playback_queue_items = @playback_queue.queue_items
      .including_item_associations
      .rank(:row_order)
      .offset(1)
  end

  def add
    @playback_queue.add_recording(@recording)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue})
      end
    end
  end

  def select
    @playback_queue.select_recording(@recording)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue: @playback_queue, playback_session: @playback_session})
      end
    end
  end

  def remove
    @playback_queue.remove_recording(@recording)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue})
      end
    end
  end

  private

  def set_recording
    @recording = Recording.find(params[:recording_id])
    authorize @recording, :play?
  end
end
