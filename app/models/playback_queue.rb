class PlaybackQueue < ApplicationRecord
  belongs_to :user
  has_many :queue_items, dependent: :delete_all
  has_many :recordings, through: :queue_items, source: :item, source_type: "Recording"
  has_many :tandas, through: :queue_items, source: :item, source_type: "Tanda"
  belongs_to :current_item, class_name: "QueueItem", optional: true

  validates :user, presence: true

  # Public methods for loading different types of content
  def load_recordings(recordings, start_with: nil)
    clear_queue_and_load(recordings, start_with)
  end

  def load_playlist(playlist, start_with: nil)
    recordings = playlist.recordings.order(:position).to_a
    clear_queue_and_load(recordings, start_with)
  end

  def load_tanda(tanda, start_with: nil)
    recordings = tanda.recordings.order(:position).to_a
    clear_queue_and_load(recordings, start_with)
  end

  # Playback control methods
  def play_recording(recording)
    queue_item = find_or_create_queue_item(recording)
    update!(current_item: queue_item)
  end

  def next_item
    current_item&.update!(row_order_position: :last)
    reload
    update!(current_item: queue_items.rank(:row_order).first)
  end

  def previous_item
    queue_items.rank(:row_order).last&.update!(row_order_position: :first)
    reload
    update!(current_item: queue_items.rank(:row_order).first)
  end

  # Queue management methods
  def add_recording(recording)
    find_or_create_queue_item(recording)
  end

  def select_recording(recording)
    queue_item = queue_items.find_by(item: recording)
    return unless queue_item

    update!(current_item: queue_item)
    PlaybackSession.find_or_create_by!(user:).play
  end

  def remove_recording(recording)
    queue_item = queue_items.find_by(item: recording)
    return unless queue_item

    if current_item == queue_item
      next_item = queue_items.where.not(id: queue_item.id).rank(:row_order).first
      update!(current_item: next_item)
    end

    queue_item.destroy
  end

  def ensure_default_items
    return unless queue_items.empty?

    recordings = Recording.limit(10)
    recordings.each { |recording| queue_items.build(item: recording) }
    save!
  end

  private

  def clear_queue_and_load(recordings, start_with)
    update!(current_item: nil)
    queue_items.delete_all

    if start_with
      start_index = recordings.index(start_with)
      recordings = recordings.rotate(start_index) if start_index
    end

    queue_items_data = recordings.each_with_index.map do |rec, index|
      {
        playback_queue_id: id,
        item_type: rec.class.name,
        item_id: rec.id,
        row_order: (index + 1) * 100,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    QueueItem.insert_all(queue_items_data)
    queue_items.reload

    update!(current_item: queue_items.rank(:row_order).first)
  end

  def find_or_create_queue_item(recording)
    queue_item = queue_items.find_or_initialize_by(item: recording)
    if queue_item.new_record?
      queue_item.row_order_position = :last
      queue_item.save!
    end
    queue_item
  end
end
