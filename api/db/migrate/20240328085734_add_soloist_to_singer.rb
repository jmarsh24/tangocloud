class AddSoloistToSinger < ActiveRecord::Migration[7.1]
  def change
    add_column :singers, :soloist, :boolean, default: false
  end
end
