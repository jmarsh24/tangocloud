class CreateCouples < ActiveRecord::Migration[7.1]
  def change
    create_table :couples, id: :uuid do |t|
      t.belongs_to :dancer, null: false, foreign_key: {to_table: :dancers}, type: :uuid
      t.belongs_to :partner, null: false, foreign_key: {to_table: :dancers}, type: :uuid
    end

    add_index :couples, [:dancer_id, :partner_id], unique: true
  end
end
