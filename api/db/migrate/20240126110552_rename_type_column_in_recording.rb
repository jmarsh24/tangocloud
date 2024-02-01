class RenameTypeColumnInRecording < ActiveRecord::Migration[7.1]
  def change
    rename_column :recordings, :type, :recording_type
  end
end
