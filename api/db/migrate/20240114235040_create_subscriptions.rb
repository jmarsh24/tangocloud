class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_enum :subscription_type, ["free", "premium", "hifi"]
    create_table :subscriptions do |t|
      t.string :name, null: false
      t.string :description
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
       t.integer :subscription_type, null: false, default: 0
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
