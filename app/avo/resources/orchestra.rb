class Avo::Resources::Orchestra < Avo::BaseResource
  self.includes = [:recordings, :singers, :compositions, :orchestra_roles, :orchestra_periods]
  self.attachments = [:image]
  self.search = {
    query: -> do
      Orchestra.search(params[:q]).map do |result|
        {
          _id: result.id,
          _label: result.name,
          _url: avo.resources_orchestras_path(result),
          _description: result.display_name,
          _avatar: result.image&.url
        }
      end
    end
  }
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      query.friendly.find id
    end
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :image, as: :file, is_image: true, accept: "image/*"
    field :display_name, as: :text
    field :name, as: :text, readonly: true
    field :sort_name, as: :text, only_on: :show
    field :slug, as: :text, readonly: true, only_on: :show
    field :recordings, as: :has_many
    field :singers, as: :has_many, through: :recordings
    field :compositions, as: :has_many, through: :recordings
    field :orchestra_roles, as: :has_many
    field :orchestra_periods, as: :has_many
  end
end
