class PlaybackQueue < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  has_many :queue_items, -> { rank(:row_order) }, dependent: :destroy

  ALLOWED_ITEM_TYPES = [Playlist, Tanda, Recording].freeze

  def active_item
    queue_items.find_by(active: true) if queue_items.active_item.present?
  end

  def play_next!
    ActiveRecord::Base.transaction do
      # Deactivate the current active item
      current_active = queue_items.find_by(active: true)
      if current_active
        current_active.update!(active: false)

        # Check if there is a next item in now_playing
        now_playing_items = queue_items.now_playing.order(:row_order)
        next_now_playing_item = now_playing_items.where("row_order > ?", current_active.row_order).first

        if next_now_playing_item
          # Set the next item in now_playing as active
          next_now_playing_item.update!(active: true)
          return
        else
          # Clear now_playing when it finishes
          queue_items.now_playing.delete_all
        end
      end

      # If no more items in now_playing or no active item, proceed to next item in the queue
      next_item = queue_items.next_up.order(:row_order).first

      if next_item
        # Handle the new item
        if next_item.item.is_a?(Tanda)
          # Add recordings from the Tanda to now_playing
          tanda_recordings = next_item.item.tanda_recordings.map(&:recording)
          tanda_recordings.each_with_index do |recording, index|
            add_item(recording, section: :now_playing, tanda_id: next_item.item.id, active: index.zero?)
          end
        else
          # Add the single item to now_playing
          add_item(next_item.item, section: :now_playing, active: true)
        end

        # Remove the next item from the queue
        next_item.destroy
      else
        # Refill the auto queue if no next item is found
        refill_auto_queue

        next_item = queue_items.auto_queue.order(:row_order).first
        if next_item
          # Handle the refilled item
          if next_item.item.is_a?(Tanda)
            # Add recordings from the Tanda to now_playing
            tanda_recordings = next_item.item.tanda_recordings.map(&:recording)
            tanda_recordings.each_with_index do |recording, index|
              add_item(recording, section: :now_playing, tanda_id: next_item.item.id, active: index.zero?)
            end
          else
            # Add the single item to now_playing
            add_item(next_item.item, section: :now_playing, active: true)
          end
        end
      end
    end
  end

  def load_source(source, shuffle: false)
    ActiveRecord::Base.transaction do
      clear_items!

      update!(source:)

      items_to_add = case source
      when Playlist
        playlist_items = shuffle ? source.playlist_items.shuffle : source.playlist_items
        playlist_items.map(&:item)
      when Tanda
        [source]
      when Recording
        [source]
      end

      now_playing_item = items_to_add.shift

      if now_playing_item.is_a?(Tanda)
        tanda_recordings = now_playing_item.tanda_recordings.map(&:recording)

        tanda_recordings.each_with_index do |recording, index|
          add_item(recording, position: index + 1, section: :now_playing, tanda_id: now_playing_item.id, active: index.zero?)
        end
      elsif now_playing_item
        add_item(now_playing_item, section: :now_playing, active: true)
      end
      add_items(items_to_add, section: :auto_queue) unless items_to_add.empty?
    end
  end

  def load_source_with_recording(source, item, shuffle: false)
    ActiveRecord::Base.transaction do
      clear_items!

      update!(source:)

      items_to_add = case source
      when Playlist
        playlist_items = shuffle ? source.playlist_items.shuffle : source.playlist_items
        playlist_items.map(&:item)
      when Tanda
        [source]
      when Recording
        [source]
      end

      now_playing_item = items_to_add.shift
      add_item(now_playing_item, section: :now_playing, active: true) if now_playing_item
      add_items(items_to_add, section: :auto_queue) unless items_to_add.empty?
    end
  end

  def add_items(items, position: :last, section: :next_up, tanda_id: nil)
    ActiveRecord::Base.transaction do
      items.each_with_index do |item, index|
        add_item(item, position: ((position == :last) ? :last : index + 1), section:, tanda_id:)
      end
    end
  end

  def add_item(item, position: :last, section: :next_up, tanda_id: nil, active: false)
    queue_item = queue_items.find_or_initialize_by(item:)
    queue_item.tanda_id = tanda_id
    queue_item.active = active
    queue_item.row_order_position = position if section == :next_up
    queue_item.section = section
    queue_item.save!
    queue_item
  end

  def refill_auto_queue
    return unless source.present?

    items_to_add = case source
    when Playlist
      source.playlist_items.map(&:item)
    when Tanda
      source.tanda_recordings
    else
      [source]
    end

    add_items(items_to_add, section: :auto_queue)
  end

  def shuffle!
    queue_items.shuffle.each_with_index do |item, index|
      item.update!(row_order: index + 1)
    end
  end

  def clear_next_up!
    queue_items.next_up.delete_all
  end

  def clear_items!
    queue_items.delete_all
  end
end

# == Schema Information
#
# Table name: playback_queues
#
#  id              :uuid             not null, primary key
#  user_id         :uuid             not null
#  current_item_id :uuid
#  source_type     :string
#  source_id       :uuid
#  active          :boolean          default(FALSE), not null
#  position        :integer          default(0), not null
#  system          :boolean          default(FALSE), not null
#
