class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, index: {unique: true}
      t.string :password_digest, null: true

      t.boolean :verified, null: false, default: false

      t.string :provider
      t.string :uid

      t.string :username, null: true, index: {unique: true}
      t.string :first_name
      t.string :last_name
      t.boolean :admin, null: false, default: false

      t.timestamps
    end
  end
end
