class CreateCouples < ActiveRecord::Migration[7.1]
  def change
    create_table :couples do |t|
      t.belongs_to :dancer, null: false, foreign_key: {to_table: :dancers}
      t.belongs_to :partner, null: false, foreign_key: {to_table: :dancers}
    end
    add_index :couples, [:dancer_id, :partner_id], unique: true
  end
end
