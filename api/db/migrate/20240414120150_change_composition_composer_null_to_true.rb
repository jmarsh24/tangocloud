class ChangeCompositionComposerNullToTrue < ActiveRecord::Migration[7.1]
  def change
    change_column_null :compositions, :composer_id, true
  end
end
