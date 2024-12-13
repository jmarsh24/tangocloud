class QueuesController < ApplicationController
  include RemoteModal

  respond_with_remote_modal only: [:show]

  before_action :authorize_playback_queue, only: [:show, :play_now, :add_to, :clear, :shuffle]

  def show
    @playback_queue_items = @playback_queue.queue_items
      .including_item_associations
      .rank(:row_order)
      .offset(1)
  end

  def play_now
    item = find_item(params[:item_type], params[:item_id])

    ActiveRecord::Base.transaction do
      if params[:parent_id].present? && params[:parent_type].present?
        parent = find_item(params[:parent_type], params[:parent_id])
        queue_manager.load_parent_with_recording(parent, item, shuffle: params[:shuffle] == "true")
      else
        queue_manager.load_item(item, shuffle: params[:shuffle] == "true")
      end

      playback_session.play(reset_position: true)
    end

    respond_with_updated_queue
  end

  def add_to
    item = find_item(params[:item_type], params[:item_id])

    ActiveRecord::Base.transaction do
      if item.is_a?(Recording)
        queue_manager.add_to_queue([item])
      elsif item.is_a?(Playlist)
        items_to_add = item.playlist_items.map(&:item)
        queue_manager.add_to_queue(items_to_add)
      elsif item.is_a?(Tanda)
        queue_manager.add_to_queue([item])
      end
    end

    respond_with_updated_queue
  end

  def clear
    queue_manager.clear_next_up!

    respond_with_updated_queue
  end

  def shuffle
    queue_manager.shuffle!

    respond_with_updated_queue
  end

  private

  def authorize_playback_queue
    authorize @playback_queue
  end

  def find_item(type, id)
    klass = type.capitalize.constantize
    raise ArgumentError, "Invalid item type" unless QueueItem.validators_on(:item_type).first.options[:in].include?(klass.name)

    klass.find(id)
  rescue NameError
    raise ArgumentError, "Invalid item type"
  end

  def queue_manager
    @queue_manager ||= QueueManager.new(playback_queue: @playback_queue, now_playing: @now_playing)
  end

  def playback_session
    @playback_session ||= PlaybackSession.find_or_create_by!(user: current_user)
  end

  def respond_with_updated_queue
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("music-player", partial: "shared/music_player", locals: {now_playing: @now_playing, playback_session: @playback_session}, method: "morph"),
          turbo_stream.update("queue", partial: "queues/queue", locals: {playback_queue: @playback_queue, playback_session: @playback_session, now_playing: @now_playing})
        ]
      end
    end
  end
end
