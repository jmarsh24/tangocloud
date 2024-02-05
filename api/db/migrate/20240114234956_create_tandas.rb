class CreateTandas < ActiveRecord::Migration[7.1]
  def change
    create_table :tandas do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :public, null: false, default: true
      t.belongs_to :audio_transfer, null: false, foreign_key: true
      t.belongs_to :user, null: false
      t.timestamps
    end
  end
end
