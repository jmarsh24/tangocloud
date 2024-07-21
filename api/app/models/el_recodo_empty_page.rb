class ElRecodoEmptyPage < ApplicationRecord
  validates :ert_number, presence: true, uniqueness: true
end
