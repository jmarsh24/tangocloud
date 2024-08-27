class ExternalCatalog::ElRecodo::EmptyPage < ApplicationRecord
  validates :ert_number, presence: true
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_empty_pages
#
#  id         :uuid             not null, primary key
#  ert_number :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
