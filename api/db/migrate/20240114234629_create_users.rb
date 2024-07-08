class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: true, index: {unique: true}
      t.boolean :admin, null: false, default: false

      t.timestamps
    end
  end
end
