class Avo::Resources::ExternalCatalogElRecodoOrchestra < Avo::BaseResource
  self.includes = [:person_roles, :songs]
  self.attachments = [:image]
  self.model_class = ::ExternalCatalog::ElRecodo::Orchestra
  self.search = {
    query: -> {
             query.search(params[:q],
               fields: [:name], match: :word_start,
               misspellings: {below: 5})
           }
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
