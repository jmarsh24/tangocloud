class LibraryItem < ApplicationRecord
  include RankedModel
  
  belongs_to :user_library
  belongs_to :item, polymorphic: true

  ranks :row_order, with_same: :user_library_id

  validates :item_type, presence: true
  validates :item_id, presence: true
end

# == Schema Information
#
# Table name: library_items
#
#  id              :uuid             not null, primary key
#  user_library_id :uuid             not null
#  item_type       :string           not null
#  item_id         :uuid             not null
#  row_order       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
