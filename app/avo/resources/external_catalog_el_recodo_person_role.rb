class Avo::Resources::ExternalCatalogElRecodoPersonRole < Avo::BaseResource
  self.includes = [:person, :song, {person: [image_attachment: :blob]}]
  self.model_class = ::ExternalCatalog::ElRecodo::PersonRole
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id, hide_on: [:index]
    field :role, as: :text
    field :image, as: :file, is_image: true do
      record.person.image
    end
    field :role, as: :text do
      record.role.capitalize
    end
    field :el_recodo, as: :text do
      link_to "Link", "https://el-recodo.com/#{record.person.path}", target: "_blank"
    end
    field :person, as: :belongs_to
    field :song, as: :belongs_to
  end
end
