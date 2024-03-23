class AddPlaybackCountToRecording < ActiveRecord::Migration[7.1]
  def change
    add_column :recordings, :playbacks_count, :integer, default: 0

    Recording.find_each do |recording|
      Recording.reset_counters(recording.id, :playbacks)
    end
  end
end
