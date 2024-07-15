class CreateCompositions < ActiveRecord::Migration[7.1]
  def change
    create_table :compositions, id: :uuid do |t|
      t.string :title, null: false

      t.timestamps
    end
  end
end
