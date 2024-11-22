class CreateAcrCloudRecognitions < ActiveRecord::Migration[8.0]
  def change
    create_enum :acr_cloud_recognition_status, %w[pending processing completed failed]

    create_table :acr_cloud_recognitions, id: :uuid do |t|
      t.belongs_to :digital_remaster, type: :uuid, null: false
      t.enum :status, enum_type: :acr_cloud_recognition_status, default: "pending", null: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
