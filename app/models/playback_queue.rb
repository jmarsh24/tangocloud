class PlaybackQueue < ApplicationRecord
  belongs_to :user
  has_many :queue_items, dependent: :delete_all
  has_many :recordings, through: :queue_items, source: :item, source_type: "Recording"
  has_many :tandas, through: :queue_items, source: :item, source_type: "Tanda"
  belongs_to :current_item, class_name: "QueueItem", optional: true

  validates :user, presence: true

  def load_recordings(recordings, start_with: nil)
    ActiveRecord::Base.transaction do
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
          row_order: index + 1,
          created_at: Time.current,
          updated_at: Time.current
        }
      end

      QueueItem.insert_all(queue_items_data)
      queue_items.reload

      update!(current_item: queue_items.rank(:row_order).first)
    end
  end

  def load_playlist(playlist, start_with: nil)
    ActiveRecord::Base.transaction do
      update!(current_item: nil)
      queue_items.delete_all

      recordings = playlist.recordings.order(:position).to_a

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
  end

  def load_tanda(tanda, start_with: nil)
    ActiveRecord::Base.transaction do
      update!(current_item: nil)
      queue_items.delete_all

      recordings = tanda.recordings.order(:position).to_a

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
  end

  def play_recording(recording)
    ActiveRecord::Base.transaction do
      queue_item = queue_items.find_by(item: recording)

      if queue_item
        queue_item.update!(row_order_position: :first)
      else
        queue_item = queue_items.create!(item: recording, row_order_position: :first)
      end

      update!(current_item: queue_item)
    end
  end

  def next_item
    ActiveRecord::Base.transaction do
      current_item&.update!(row_order_position: :last)
      reload
      update!(current_item: queue_items.rank(:row_order).first)
    end
  end

  def previous_item
    ActiveRecord::Base.transaction do
      queue_items.rank(:row_order).last&.update!(row_order_position: :first)
      reload
      update!(current_item: queue_items.rank(:row_order).first)
    end
  end

  def add_recording(recording)
    queue_item = queue_items.find_or_initialize_by(item: recording)
    if queue_item.new_record?
      queue_item.row_order_position = :last
      queue_item.save!
    end
    queue_item
  end

  def select_recording(recording)
    queue_item = queue_items.find_by(item: recording)
    return unless queue_item

    update!(current_item: queue_item)
    PlaybackSession.find_or_create_by!(user:).play
  end

  def remove_recording(recording)
    ActiveRecord::Base.transaction do
      queue_item = queue_items.find_by(item: recording)
      return unless queue_item

      if current_item == queue_item
        next_item = queue_items.where.not(id: queue_item.id).rank(:row_order).first
        update!(current_item: next_item)
      end

      queue_item.destroy
    end
  end

  def ensure_default_items
    return unless queue_items.empty?

    recordings = Recording.random.limit(10)
    recordings.each { |recording| queue_items.build(item: recording) }
    save!
  end
end

# == Schema Information
#
# Table name: playback_queues
#
#  id              :uuid             not null, primary key
#  user_id         :uuid             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_item_id :uuid
#
