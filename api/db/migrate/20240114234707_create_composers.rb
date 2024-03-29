class CreateComposers < ActiveRecord::Migration[7.1]
  def change
    create_table :composers, id: :uuid do |t|
      t.string :name, null: false
      t.date :birth_date
      t.date :death_date
      t.string :slug, index: {unique: true}, null: false
      t.timestamps
    end
  end
end
