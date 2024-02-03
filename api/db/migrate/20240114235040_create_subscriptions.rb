class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_enum :subscription_type, ["free", "premium", "hifi"]
    create_table :subscriptions, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.enum :subscription_type, default: "free", null: false, enum_type: :subscription_type
      t.belongs_to :user, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
