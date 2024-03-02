class CreateHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :histories, id: :uuid do |t|
      t.belongs_to :user, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
