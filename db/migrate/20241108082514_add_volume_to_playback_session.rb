class AddVolumeToPlaybackSession < ActiveRecord::Migration[8.0]
  def change
    add_column :playback_sessions, :volume, :integer, default: 100
    add_column :playback_sessions, :muted, :boolean, default: false
  end
end
