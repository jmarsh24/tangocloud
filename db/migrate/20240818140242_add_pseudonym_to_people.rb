class AddPseudonymToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :pseudonym, :string
  end
end
