# frozen_string_literal: true

class DropUserSettingsAndPreferences < ActiveRecord::Migration[7.1]
  def change
    drop_table :user_settings
    drop_table :user_preferences
  end
end
