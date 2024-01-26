# frozen_string_literal: true

class RenameTypeColumnInSubscription < ActiveRecord::Migration[7.1]
  def change
    rename_column :subscriptions, :type, :subscription_type
  end
end
