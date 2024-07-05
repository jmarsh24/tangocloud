class CreateAudioVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_variants, id: :uuid do |t|
      t.integer :duration, null: false, default: 0
      t.string :format, null: false
      t.string :codec, null: false
      t.integer :bit_rate
      t.integer :sample_rate
      t.integer :channels
      t.integer :length, null: false, default: 0
      t.jsonb :metadata, default: {}, null: false
      t.belongs_to :audio_transfer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
