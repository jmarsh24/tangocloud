# frozen_string_literal: true

class RemoveNullConstraintUserPreferences < ActiveRecord::Migration[7.1]
  def change
    change_column_null :user_preferences, :username, true
  end
end
