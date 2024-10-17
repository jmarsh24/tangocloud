class CreateCompositions < ActiveRecord::Migration[7.1]
  def change
    create_table :compositions do |t|
      t.string :title, null: false

      t.timestamps
    end
  end
end
