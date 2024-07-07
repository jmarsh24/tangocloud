class CreateTandas < ActiveRecord::Migration[7.1]
  def change
    create_table :tandas, id: :uuid do |t|
      t.string :title, null: false
      t.string :subtitle, null: true
      t.string :description
      t.boolean :public, null: false, default: true
      t.belongs_to :user, null: false, type: :uuid

      t.timestamps
    end
  end
end
