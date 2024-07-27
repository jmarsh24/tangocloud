class Avo::Resources::ExternalCatalogElRecodoPersonRole < Avo::BaseResource
  # self.includes = [:person, :song]
  # self.attachments = []
  self.model_class = ::ExternalCatalog::ElRecodo::PersonRole
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :image, as: :file, is_image: true do
      record.person.image
    end
    field :role, as: :text do
      record.role.capitalize
    end
    field :external_link, as: :text do
      link_to "Link", "https://el-recodo.com/#{record.person.path}", target: "_blank"
    end
    field :person, as: :belongs_to, resource: Avo::Resources::ExternalCatalogElRecodoPerson
    # field :song, as: :belongs_to, resource: Avo::Resources::ExternalCatalogElRecodoSong
  end
end
