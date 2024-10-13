class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, index: {unique: true}
      t.string :password_digest, null: false
      t.string :provider
      t.string :uid
      t.boolean :admin, null: false, default: false
      t.datetime :approved_at

      t.boolean :verified, null: false, default: false

      t.timestamps
    end
  end
end
