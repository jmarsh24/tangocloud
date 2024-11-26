class Avo::Resources::ExternalCatalogElRecodoOrchestra < Avo::BaseResource
  self.includes = [:person_roles, :songs]
  self.attachments = [:image]
  self.model_class = ::ExternalCatalog::ElRecodo::Orchestra
  self.search = {
    query: -> do
      ExternalCatalog::ElRecodo::Orchestra.search(params[:q]).map do |result|
        {
          _id: result.id,
          _label: result.name,
          _url: avo.resources_external_catalog_el_recodo_orchestras_path(result),
          _avatar: result.image&.url
        }
      end
    end,
    item: -> do
      {
        title: "[#{record.id}] #{record.name}",
        subtitle: record.subtitle
      }
    end
  }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :image, as: :file, is_image: true
    field :name, as: :text
    field :el_recodo, as: :text do
      link_to "Link", "https://el-recodo.com/#{record.path}", target: "_blank"
    end
    field :songs, as: :has_many
    field :person_roles, as: :has_many, through: :songs
    field :people, as: :has_many, through: :person_roles
  end
end
