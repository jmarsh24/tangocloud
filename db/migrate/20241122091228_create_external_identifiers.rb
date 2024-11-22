class CreateExternalIdentifiers < ActiveRecord::Migration[8.0]
  def change
    create_table :external_identifiers, id: :uuid do |t|
      t.belongs_to :recording, type: :uuid, null: false
      t.belongs_to :acr_cloud_recognition, type: :uuid, null: true
      t.string :service_name, null: false
      t.string :external_id, null: false
      t.jsonb :metadata, default: {}

      t.timestamps

      t.index [:service_name, :external_id], unique: true
    end
  end
end
