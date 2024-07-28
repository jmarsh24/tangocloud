class Avo::Resources::ExternalCatalogElRecodoEmptyPage < Avo::BaseResource
  self.model_class = ::ExternalCatalog::ElRecodo::EmptyPage
  self.visible_on_sidebar = false

  def fields
    field :id, hide_on: [:index]
    field :ert_number, as: :number
  end
end
