class RenameLabelIdToRecordLabelId < ActiveRecord::Migration[7.1]
  def change
    rename_column :recordings, :label_id, :record_label_id
  end
end
