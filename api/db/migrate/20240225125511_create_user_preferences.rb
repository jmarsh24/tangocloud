class CreateUserPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :user_preferences, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
  end
end
