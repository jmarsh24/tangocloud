class CreateElRecodoPersons < ActiveRecord::Migration[7.1]
  def change
    create_table :el_recodo_people, id: :uuid do |t|
      t.date :birth_date
      t.date :death_date
      t.string :real_name
      t.string :nicknames, array: true
      t.string :place_of_birth
      t.string :url
      t.string :image_url
      t.datetime :synced_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :page_updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
