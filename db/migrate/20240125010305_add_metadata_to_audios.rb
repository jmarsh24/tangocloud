# frozen_string_literal: true

class AddMetadataToAudios < ActiveRecord::Migration[7.1]
  def change
    add_column :audios, :bit_rate_mode, :string
    add_column :audios, :codec, :string
    remove_column :audios, :duration, :integer
    remove_column :audios, :format, :string
    add_column :audios, :length, :float
    add_column :audios, :encoder, :string
  end
end
