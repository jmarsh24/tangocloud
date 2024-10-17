FactoryBot.define do
  factory :external_catalog_el_recodo_empty_page, class: "ExternalCatalog::ElRecodo::EmptyPage" do
    ert_number { 1 }
  end
end

# == Schema Information
#
# Table name: external_catalog_el_recodo_empty_pages
#
#  id         :integer          not null, primary key
#  ert_number :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
