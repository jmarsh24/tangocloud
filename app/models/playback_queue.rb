class PlaybackQueue < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true, optional: true

  has_many :queue_items, -> { rank(:row_order) }, dependent: :destroy

  ALLOWED_ITEM_TYPES = [Playlist, Tanda, Recording].freeze

  def active_item
    queue_items.find_by(active: true) if queue_items.active_item.present?
  end

  def play_next!
    ActiveRecord::Base.transaction do
      current_active = queue_items.find_by(active: true)
      if current_active
        current_active.update!(active: false)

        now_playing_items = queue_items.now_playing.order(:row_order)
        next_now_playing_item = now_playing_items.where("row_order > ?", current_active.row_order).first

        if next_now_playing_item
          next_now_playing_item.update!(active: true)
          return
        else
          tanda_id = now_playing_items.first.tanda_id
          if tanda_id
            tanda = Tanda.find(tanda_id)
            add_item(tanda, section: :played)
          else
            now_playing_items.each do |item|
              add_item(item.item, section: :played)
            end
          end

          now_playing_items.delete_all
        end
      end

      next_item = queue_items.next_up.order(:row_order).first || queue_items.auto_queue.order(:row_order).first

      if next_item
        if next_item.item.is_a?(Tanda)
          tanda_recordings = next_item.item.tanda_recordings.map(&:recording)
          tanda_recordings.each_with_index do |recording, index|
            add_item(recording, section: :now_playing, tanda_id: next_item.item.id, active: index.zero?)
          end
        else
          add_item(next_item.item, section: :now_playing, active: true)
        end
        next_item.destroy
      else
        refill_auto_queue
        next_item = queue_items.auto_queue.order(:row_order).first
        if next_item
          if next_item.item.is_a?(Tanda)
            tanda_recordings = next_item.item.tanda_recordings.map(&:recording)
            tanda_recordings.each_with_index do |recording, index|
              add_item(recording, section: :now_playing, tanda_id: next_item.item.id, active: index.zero?)
            end
          else
            add_item(next_item.item, section: :now_playing, active: true)
          end
          next_item.destroy
        end
      end
    end
  end

  def previous!
    ActiveRecord::Base.transaction do
      current_active = queue_items.find_by(active: true)
      return unless current_active # Exit early if no active item

      now_playing_items = queue_items.now_playing.order(:row_order)
      played_items = queue_items.where(section: :played).order(:row_order)

      # Step 1: Navigate within the current Tanda if it exists
      if current_active.tanda_id
        current_tanda_items = now_playing_items.where(tanda_id: current_active.tanda_id)
        current_index = current_tanda_items.index(current_active)

        if current_index == 0 && played_items.empty?
          return
        end

        if current_index > 0
          # Move to the previous recording in the Tanda
          current_active.update!(active: false)
          previous_item = current_tanda_items[current_index - 1]
          previous_item.update!(active: true)
          return
        else
          # Already at the first recording; move the Tanda to next_up
          tanda_id = current_active.tanda_id
          tanda = Tanda.find(tanda_id)
          add_item(tanda, section: :next_up, position: :first)
          now_playing_items.where(tanda_id: tanda_id).delete_all
        end
      end

      # Step 2: Bring the last played Tanda or recording into now_playing
      if played_items.any?
        last_played_item = played_items.last.item

        if last_played_item.is_a?(Tanda)
          current_tanda = Tanda.find(current_active.tanda_id)
          queue_items.now_playing.delete_all
          last_played_item.tanda_recordings.rank(:position).each_with_index do |tanda_recording, index|
            active = current_tanda.tanda_recordings.size == index + 1
            add_item(tanda_recording.recording, section: :now_playing, tanda_id: last_played_item.id, active:, position: index + 1)
          end
        elsif last_played_item.is_a?(Recording)
          add_item(last_played_item, section: :next_up, active: true)
        end

        # Remove the restored item from played
        played_items.last.destroy
      end
    end
  end

  def load_source(source, shuffle: false)
    ActiveRecord::Base.transaction do
      clear_items!

      update!(source:)

      items_to_add = case source
      when Playlist
        playlist_items = shuffle ? source.playlist_items.shuffle : source.playlist_items.rank(:position)
        playlist_items.map(&:item)
      when Tanda
        source.tanda_recordings.map(&:recording)
      when Recording
        [source]
      end

      now_playing_item = items_to_add.shift

      if now_playing_item.is_a?(Tanda)
        tanda_recordings = now_playing_item.tanda_recordings.rank(:position).map(&:recording)

        tanda_recordings.each_with_index do |recording, index|
          add_item(recording, position: index + 1, section: :now_playing, tanda_id: now_playing_item.id, active: index.zero?)
        end
      elsif now_playing_item
        add_item(now_playing_item, section: :now_playing, active: true)
      end
      add_items(items_to_add, section: :auto_queue) unless items_to_add.empty?
    end
  end

  def load_source_with_item(source, item)
    ActiveRecord::Base.transaction do
      clear_items!

      update!(source:)

      items_to_add = case source
      when Playlist
        playlist_items = source.playlist_items.rank(:position).map(&:item)
        playlist_items.drop_while { _1 != item }.drop(1)
      when Tanda
        source.tanda_recordings.rank(:position).map(&:recording)
      when Recording
        [source]
      end

      if item.is_a?(Tanda)
        tanda_recordings = item.tanda_recordings.map(&:recording)
        tanda_recordings.each_with_index do |recording, index|
          add_item(recording, position: index + 1, section: :now_playing, tanda_id: item.id, active: index.zero?)
        end
        add_items(items_to_add, section: :auto_queue) unless items_to_add.empty?
      elsif source.is_a?(Tanda)
        recordings = source.tanda_recordings.rank(:position).map(&:recording)

        recordings.each_with_index do |recording, index|
          add_item(recording, position: index, section: :now_playing, tanda_id: source.id, active: item == recording)
        end
      else
        add_item(item, section: :now_playing, active: true)
        add_items(items_to_add, section: :auto_queue) unless items_to_add.empty?
      end
    end
  end

  def load_recordings(recordings, start_with:)
    ActiveRecord::Base.transaction do
      clear_items!
      update!(source: nil)

      now_playing = [start_with]
      auto_queue = recordings - now_playing

      now_playing.each_with_index do |recording, index|
        add_item(recording, section: :now_playing, active: index.zero?)
      end

      add_items(auto_queue, section: :auto_queue)
    end
  end

  def add_items(items, position: :last, section: :next_up, tanda_id: nil)
    return if items.empty?

    batch_data = items.map.with_index do |item, index|
      {
        playback_queue_id: id,
        item_type: item.class.name,
        item_id: item.id,
        tanda_id: tanda_id,
        section: section,
        active: false,
        row_order: (position == :last) ? nil : index + 1
      }
    end

    QueueItem.insert_all(batch_data)
  end

  def add_item(item, position: :last, section: :next_up, tanda_id: nil, active: false)
    queue_item = queue_items.create!(item:)
    queue_item.tanda_id = tanda_id
    queue_item.active = active
    queue_item.row_order_position = position
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
