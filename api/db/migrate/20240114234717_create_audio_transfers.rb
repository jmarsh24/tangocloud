class CreateAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_transfers, id: :uuid do |t|
      t.string :external_id
      t.integer :position, default: 0, null: false
      t.belongs_to :album, foreign_key: true, type: :uuid
      t.belongs_to :transfer_agent, foreign_key: true, type: :uuid
      t.belongs_to :recording, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
