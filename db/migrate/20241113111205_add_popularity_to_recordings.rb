class AddPopularityToRecordings < ActiveRecord::Migration[8.0]
  def change
    add_column :recordings, :playlists_count, :integer, default: 0, null: false
    add_column :recordings, :tandas_count, :integer, default: 0, null: false
    add_column :tandas, :playlists_count, :integer, default: 0, null: false
    add_column :recordings, :popularity_score, :decimal, precision: 5, scale: 2, default: 0.0, null: false
  end
end
