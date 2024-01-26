# frozen_string_literal: true

class RenameLabelToRecordLabel < ActiveRecord::Migration[7.1]
  def change
    rename_table :labels, :record_labels
  end
end
