class AddGenreToTandas < ActiveRecord::Migration[8.0]
  def change
    add_reference :tandas, :genre, foreign_key: true, type: :uuid
  end
end
