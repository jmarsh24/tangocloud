class AddUniqueIndexToAcrCloudRecognitions < ActiveRecord::Migration[8.0]
  def change
    remove_index :acr_cloud_recognitions, name: "index_acr_cloud_recognitions_on_digital_remaster_id"
    add_index :acr_cloud_recognitions, :digital_remaster_id, unique: true, name: "unique_index_acr_cloud_recognitions_on_digital_remaster_id"
  end
end
