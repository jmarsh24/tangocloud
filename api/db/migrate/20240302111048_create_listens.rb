class CreateListens < ActiveRecord::Migration[7.1]
  def change
    create_table :listens, id: :uuid do |t|
      t.belongs_to :listen_history, type: :uuid, foreign_key: true
      t.belongs_to :recording, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
