class ExternalCatalog::ElRecodo::EmptyPage < ApplicationRecord
  validates :ert_number, presence: true, uniqueness: true
end
