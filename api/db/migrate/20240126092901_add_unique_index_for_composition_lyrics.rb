class AddUniqueIndexForCompositionLyrics < ActiveRecord::Migration[7.1]
  def change
    add_index :lyrics, [:composition_id, :locale], unique: true
  end
end
