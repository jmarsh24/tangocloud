class AddUniqueIndexToRecordLabels < ActiveRecord::Migration[7.1]
  def change
    add_index :record_labels, :name, unique: true
  end
end
