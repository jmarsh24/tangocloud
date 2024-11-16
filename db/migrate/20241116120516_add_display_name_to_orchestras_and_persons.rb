class AddDisplayNameToOrchestrasAndPersons < ActiveRecord::Migration[8.0]
  def change
    add_column :orchestras, :display_name, :string
    add_column :people, :display_name, :string

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE orchestras SET display_name = name;
          UPDATE people SET display_name = name;
        SQL
      end
    end
  end
end
