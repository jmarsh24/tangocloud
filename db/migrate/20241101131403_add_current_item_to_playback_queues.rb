class AddCurrentItemToPlaybackQueues < ActiveRecord::Migration[8.0]
  def change
    add_reference :playback_queues, :current_item, foreign_key: {to_table: :queue_items}, type: :uuid
  end
end
