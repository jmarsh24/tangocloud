class CreateRecordLabels < ActiveRecord::Migration[7.1]
  def change
    create_table :record_labels, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.date :founded_date

      t.timestamps
    end
  end
end
