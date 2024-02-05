class CreateCompositionComposers < ActiveRecord::Migration[7.1]
  def change
    create_table :composition_composers do |t|
      t.belongs_to :composition, null: false, foreign_key: true
      t.belongs_to :composer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
