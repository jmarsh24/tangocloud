class RemoveLocaleCompositionIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :lyrics, name: "index_lyrics_on_locale_and_composition_id"
  end
end
