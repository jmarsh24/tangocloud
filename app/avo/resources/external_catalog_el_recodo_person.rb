class Avo::Resources::ExternalCatalogElRecodoPerson < Avo::BaseResource
  self.includes = [:person_roles, :songs]
  self.attachments = [:image]
  self.model_class = ::ExternalCatalog::ElRecodo::Person
  self.search = {
    query: -> {
             query.search(params[:q],
               fields: [:name],
               match: :word_start,
               misspellings: {below: 5})
           }
  }

  def fields
    field :id, as: :id, hide_on: [:index]
    field :image, as: :file, is_image: true
    field :name, as: :text
    field :birth_date, as: :date
    field :death_date, as: :date
    field :real_name, as: :text
    field :nicknames, as: :text
    field :place_of_birth, as: :text
    field :path, as: :text do
      link_to record.name, "https://el-recodo.com/#{record.path}", target: "_blank"
    end
    field :synced_at, as: :date_time, hide_on: [:index]
    field :person_roles, as: :has_many
    field :songs, as: :has_many, through: :person_roles
  end
end
