# frozen_string_literal: true

class ConvertEnumsToNative < ActiveRecord::Migration[7.1]
  def change
    create_enum :album_type, ["compilation", "original"]
    remove_column :albums, :type, :int
    change_table :albums do |t|
      t.enum :type, enum_type: :album_type, default: "compilation", null: false
    end

    create_enum :recording_type, ["studio", "live"]
    remove_column :recordings, :type, :int
    change_table :recordings do |t|
      t.enum :type, enum_type: :recording_type, default: "studio", null: false
    end

    create_enum :subscription_type, ["free", "premium", "hifi"]
    remove_column :subscriptions, :type, :int
    change_table :subscriptions do |t|
      t.enum :type, enum_type: :subscription_type, default: "free", null: false
    end
  end
end
