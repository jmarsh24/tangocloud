class AddPostgresExtensions < ActiveRecord::Migration[7.1]
  def change
    enable_extension "citext"
    enable_extension "pgcrypto"
  end
end
