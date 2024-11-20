class CreateUserLibraries < ActiveRecord::Migration[8.0]
  def change
    create_table :user_libraries, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
