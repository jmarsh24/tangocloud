class CreateAudioVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_variants do |t|
      t.string :format, null: false
      t.integer :bit_rate, null: false, default: 0
      t.belongs_to :digital_remaster, null: false, foreign_key: true

      t.timestamps
    end
  end
end
