class Avo::Resources::ExternalCatalogElRecodoEmptyPage < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::ExternalCatalog::ElRecodo::EmptyPage
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, hide_on: [:index]
    field :ert_number, as: :number
  end
end
