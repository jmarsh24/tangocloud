class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :action, null: false
      t.string :user_agent
      t.string :ip_address

      t.timestamps
    end
  end
end
