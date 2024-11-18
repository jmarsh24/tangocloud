class DropSlugFromRecordings < ActiveRecord::Migration[8.0]
  def change
    remove_column :recordings, :slug, :string
  end
end
