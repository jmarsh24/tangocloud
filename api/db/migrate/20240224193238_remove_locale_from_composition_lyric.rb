class RemoveLocaleFromCompositionLyric < ActiveRecord::Migration[7.1]
  def change
    remove_column :composition_lyrics, :locale, :string
  end
end
