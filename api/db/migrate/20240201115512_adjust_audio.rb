class AdjustAudio < ActiveRecord::Migration[7.1]
  def change
    add_column :audios, :format, :string
    remove_column :audios, :bit_depth, :integer
    remove_column :audios, :bit_rate_mode, :string
    remove_column :audios, :encoder, :string
    change_column :audios, :sample_rate, :integer
    change_column :audios, :channels, :integer
  end
end
