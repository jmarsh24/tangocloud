class CreateCompositionComposers < ActiveRecord::Migration[7.1]
  def change
    create_table :composition_composers, id: :uuid do |t|
      t.belongs_to :composition, null: false, foreign_key: true, type: :uuid
      t.belongs_to :composer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
