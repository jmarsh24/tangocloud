class CreateLabels < ActiveRecord::Migration[7.1]
  def change
    create_table :labels, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.date :founded_date

      t.timestamps
    end
  end
end
