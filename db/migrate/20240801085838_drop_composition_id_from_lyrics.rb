class DropCompositionIdFromLyrics < ActiveRecord::Migration[7.1]
  def change
    remove_column :lyrics, :composition_id, :uuid
  end
end
