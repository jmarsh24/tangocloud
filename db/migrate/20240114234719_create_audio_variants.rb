class CreateAudioVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_variants, id: :uuid do |t|
      t.string :format, null: false
      t.integer :bit_rate, null: false, default: 0
      t.belongs_to :digital_remaster, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
