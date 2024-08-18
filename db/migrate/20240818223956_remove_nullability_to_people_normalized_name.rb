class RemoveNullabilityToPeopleNormalizedName < ActiveRecord::Migration[7.1]
  def change
    change_column_null :people, :normalized_name, false
  end
end
