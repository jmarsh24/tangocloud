# frozen_string_literal: true

class RemoveCountCacheFromComposition < ActiveRecord::Migration[7.1]
  def change
    remove_column :compositions, :popularity
    remove_column :compositions, :listens_count
  end
end
