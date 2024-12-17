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

        @playback_queue.load_source_with_item(parent, item)
      else
        @playback_queue.load_source(item, shuffle: params[:shuffle] == "true")
      end

      playback_session.play(reset_position: true)
    end

    respond_with_updated_queue
  end

  def play_now_with_search
    recording = Recording.find(params[:id])
    authorize recording, :play?

    filters = params.permit(:orchestra, :year, :genre, :orchestra_period, :singer).to_h.compact_blank
    sort_params = params.permit(:sort, :order).to_h.compact_blank

    sort_column = case sort_params[:sort]
    when "year" then "recordings.year"
    when "popularity" then "recordings.popularity_score"
    else "recordings.popularity_score"
    end

    sort_direction = (sort_params[:order] == "desc") ? :desc : :asc

    query = Recording::Query.new(filters.merge(items: 200))

    all_recordings = query.results.order("#{sort_column} #{sort_direction}").to_a

    recording_index = all_recordings.index(recording)

    ActiveRecord::Base.transaction do
      if recording_index
        now_playing = [recording]
        auto_queue = all_recordings[recording_index + 1..]

        @playback_queue.load_recordings(now_playing + auto_queue, start_with: recording)
      else
        @playback_queue.load_recordings(all_recordings, start_with: recording)
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
end
