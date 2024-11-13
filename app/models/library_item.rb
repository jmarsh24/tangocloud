class LibraryItem < ApplicationRecord
  include RankedModel
  
  belongs_to :user_library
  belongs_to :item, polymorphic: true

  ranks :row_order, with_same: :user_library_id

  validates :item_type, presence: true
  validates :item_id, presence: true
end