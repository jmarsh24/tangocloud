class QueueManager
  def initialize(playback_queue:, now_playing:)
    @playback_queue = playback_queue
    @now_playing = now_playing
  end

  def load_parent_with_recording(parent, recording, shuffle: false)
    validate_item_type!(parent)
    validate_item_type!(recording)

    ActiveRecord::Base.transaction do
      @playback_queue.clear_items!

      @playback_queue.update!(current_item: parent)

      parent_items = fetch_items_from_parent(parent, shuffle)

      starting_index = parent_items.index(recording)
      raise ArgumentError, "Recording not found in the parent" if starting_index.nil?

      now_playing_item = parent_items[starting_index]
      queue_items = parent_items.drop(starting_index + 1)

      set_now_playing(now_playing_item)

      @playback_queue.add_items(queue_items, source: :auto_queue)
    end
  end

  def load_item(item, shuffle: false)
    validate_item_type!(item)

    ActiveRecord::Base.transaction do
      if item.is_a?(Recording)
        set_now_playing(item)
      else
        @playback_queue.load_as_current_item(item, shuffle: shuffle)
        first_queue_item = @playback_queue.queue_items.order(:row_order).first
        set_now_playing(first_queue_item&.item)
      end
    end
  end

  def next
    ActiveRecord::Base.transaction do
      next_item = @playback_queue.queue_items.next_up.order(:row_order).first || begin
        @playback_queue.refill_auto_queue
        @playback_queue.queue_items.auto_queue.order(:row_order).first
      end

      return unless next_item

      set_now_playing(next_item.item)
      next_item.destroy
    end
  end

  def add_to_queue(items)
    @playback_queue.add_items(items, source: :next_up)
  end

  def shuffle!
    @playback_queue.shuffle!
  end

  def clear_next_up!
    @playback_queue.clear_next_up!
  end

  private

  def set_now_playing(item)
    @now_playing.update!(item:, position: 0, item_type: item.class.name)
  end

  def validate_item_type!(item)
    unless PlaybackQueue::ALLOWED_ITEM_TYPES.include?(item.class)
      raise ArgumentError, "Only Playlist, Tanda, and Recording can be added to the queue"
    end
  end

  def fetch_items_from_parent(parent, shuffle)
    case parent
    when Playlist
      items = parent.playlist_items.map(&:item)
    when Tanda
      items = parent.tanda_recordings
    else
      raise ArgumentError, "Unsupported parent type: #{parent.class.name}"
    end

    shuffle ? items.shuffle : items
  end
end
