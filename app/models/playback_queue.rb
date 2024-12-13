class PlaybackQueue < ApplicationRecord
  belongs_to :user
  has_many :queue_items, -> { rank(:row_order) }, dependent: :destroy
  belongs_to :current_item, optional: true, polymorphic: true

  ALLOWED_ITEM_TYPES = [Playlist, Tanda, Recording].freeze

  def load_as_current_item(item, shuffle: false)
    ActiveRecord::Base.transaction do
      clear_items!

      update!(current_item: item)

      items_to_add = case item
      when Playlist
        playlist_items = shuffle ? item.playlist_items.shuffle : item.playlist_items
        playlist_items.map(&:item)
      when Tanda
        tanda_items = shuffle ? item.tanda_recordings.shuffle : item.tanda_recordings
        tanda_items
      when Recording
        [item]
      end

      add_items(items_to_add, source: :auto_queue) unless items_to_add.empty?
    end
  end

  def refill_auto_queue
    return unless current_item.present?

    items_to_add = case current_item
    when Playlist
      current_item.playlist_items.map(&:item)
    when Tanda
      current_item.tanda_recordings
    else
      [current_item]
    end

    add_items(items_to_add, source: :auto_queue)
  end

  def add_items(items, position: :last, source: :next_up)
    ActiveRecord::Base.transaction do
      items.each_with_index do |item, index|
        add_item(item, position: ((position == :last) ? :last : index + 1), source: source)
      end
    end
  end

  def add_item(item, position: :last, source: :next_up)
    queue_item = queue_items.find_or_initialize_by(item:)
    if queue_item.new_record?
      queue_item.row_order_position = position
      queue_item.source = source
      queue_item.save!
    end
    queue_item
  end

  def clear_next_up!
    queue_items.next_up.destroy_all
  end

  def clear_items!
    queue_items.destroy_all
  end

  def shuffle!
    queue_items.shuffle.each_with_index do |item, index|
      item.update!(row_order: index + 1)
    end
  end
end

# == Schema Information
#
# Table name: playback_queues
#
#  id                :uuid             not null, primary key
#  user_id           :uuid             not null
#  current_item_id   :uuid
#  queue_type        :string           default("All"), not null
#  current_item_type :string
#  active            :boolean          default(FALSE), not null
#  position          :integer          default(0), not null
#  system            :boolean          default(FALSE), not null
#
