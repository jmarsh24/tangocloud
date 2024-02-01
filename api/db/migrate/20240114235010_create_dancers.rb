class CreateDancers < ActiveRecord::Migration[7.1]
  def change
    create_table :dancers, id: :uuid do |t|
      t.string :name, null: false
      t.string :nickname
      t.string :nationality
      t.date :birth_date
      t.date :death_date
      t.timestamps
    end
  end
end
