class CreateMoods < ActiveRecord::Migration[7.1]
  def change
    create_table :moods, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :moods, :name, unique: true
  end
end
