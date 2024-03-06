class CreateListenHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :listen_histories, id: :uuid do |t|
      t.belongs_to :user, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
