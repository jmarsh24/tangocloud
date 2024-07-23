class CreateElRecodoPersonRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :el_recodo_person_roles, id: :uuid do |t|
      t.references :el_recodo_person, null: false, foreign_key: true, type: :uuid
      t.references :el_recodo_song, null: false, foreign_key: true, type: :uuid
      t.string :role, null: false

      t.timestamps
    end
  end
end
