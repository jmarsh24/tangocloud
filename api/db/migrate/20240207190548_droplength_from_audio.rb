class DroplengthFromAudio < ActiveRecord::Migration[7.1]
  def change
    remove_column :audios, :length, :integer
  end
end
