class RenameLyricsIdOnCompositionLyric < ActiveRecord::Migration[7.1]
  def change
    rename_column :composition_lyrics, :lyrics_id, :lyric_id
    remove_column :composition_lyrics, :lyricist_id
  end
end
