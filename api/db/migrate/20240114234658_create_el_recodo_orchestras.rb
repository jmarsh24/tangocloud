class CreateElRecodoOrchestras < ActiveRecord::Migration[7.1]
  def change
    create_table :el_recodo_orchestras, id: :uuid do |t|
      t.string :name, null: false, default: "", index: {unique: true}
      t.timestamps
    end
  end
end
