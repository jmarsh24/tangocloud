class QueuesController < ApplicationController
  include RemoteModal

  respond_with_remote_modal only: [:show]

  before_action :authorize_playback_queue, only: [:show, :play_now, :add_to, :clear, :shuffle]

  def show
    @queue_items = @playback_queue.queue_items
      .including_item_associations
      .rank(:row_order)
  end

  def play_now
    item = find_item(params[:item_type], params[:item_id])

    ActiveRecord::Base.transaction do
      if params[:parent_id].present? && params[:parent_type].present?
        parent = find_item(params[:parent_type], params[:parent_id])
        @playback_queue.load_source_with_recording(parent, item, shuffle: params[:shuffle] == "true")
      else
        @playback_queue.load_source(item, shuffle: params[:shuffle] == "true")
      end

      playback_session.play(reset_position: true)
    end

    respond_with_updated_queue
  end

  def add_to
    item = find_item(params[:item_type], params[:item_id])
    ActiveRecord::Base.transaction do
      items_to_add = case item
      when Playlist
        item.playlist_items.map(&:item)
      when Tanda
        [item]
      when Recording
        [item]
      end

      @playback_queue.add_items(items_to_add, section: :next_up)
    end

    respond_with_updated_queue
  end

  def clear
    @playback_queue.clear_next_up!

    respond_with_updated_queue
  end

  def shuffle
    @playback_queue.shuffle!

    respond_with_updated_queue
  end

  private

  def authorize_playback_queue
    authorize @playback_queue
  end

  def find_item(type, id)
    klass = type.capitalize.constantize
    raise ArgumentError, "Invalid item type" unless klass.in?([Recording, Playlist, Tanda])

    klass.find(id)
  rescue NameError
    raise ArgumentError, "Invalid item type"
  end

  def playback_session
    @playback_session ||= PlaybackSession.find_or_create_by!(user: current_user)
  end

  def respond_with_updated_queue
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {playback_queue: @playback_queue, playback_session: @playback_session}),
          turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, queue_items: @playback_queue.queue_items.including_item_associations.rank(:row_order)})
        ]
      end
    end
  end

  def reorder_queue_after_now_playing(item)
    items = @playback_queue.queue_items.where.not(item: item).order(:row_order)
    items.each_with_index do |queue_item, index|
      queue_item.update!(row_order: index + 1)
    end
  end
end
