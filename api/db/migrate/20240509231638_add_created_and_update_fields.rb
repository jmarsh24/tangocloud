class AddCreatedAndUpdateFields < ActiveRecord::Migration[7.1]
  def change
    add_column :recordings, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :recordings, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }

    add_index :recordings, :created_at
    add_index :recordings, :updated_at

    add_column :albums, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :albums, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }

    add_column :couples, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :couples, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }

    add_column :dancer_videos, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :dancer_videos, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }

    add_index :dancer_videos, :created_at
    add_index :dancer_videos, :updated_at

    add_column :orchestras, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :orchestras, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
