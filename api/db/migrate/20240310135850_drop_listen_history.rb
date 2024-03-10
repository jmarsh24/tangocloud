class DropListenHistory < ActiveRecord::Migration[7.1]
  def change
    drop_table :listen_histories
  end
end
