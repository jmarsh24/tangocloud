class AddErrorCodeToAcrCloudRecognition < ActiveRecord::Migration[8.0]
  def change
    add_column :acr_cloud_recognitions, :error_code, :integer
    add_column :acr_cloud_recognitions, :error_message, :string
  end
end
