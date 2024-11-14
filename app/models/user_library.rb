class UserLibrary < ApplicationRecord
  belongs_to :user
  has_many :library_items, dependent: :destroy
end