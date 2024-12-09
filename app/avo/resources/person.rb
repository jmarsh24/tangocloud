class Avo::Resources::Person < Avo::BaseResource
  self.includes = [:orchestra_positions, :recording_singers, :composition_roles]
  self.attachments = [:image]

  self.search = {
    query: -> do
      Person.search(params[:q]).map do |result|
        {
          _id: result.id,
          _label: result.name,
          _url: avo.resources_people_path(result),
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

  self.index_query = -> { query.order(recordings_count: :desc) }

  def fields
    field :image, as: :file, is_image: true, accept: "image/*"
    field :id, as: :id, readonly: true, only_on: :show
    field :display_name, as: :text
    field :name, as: :text, readonly: true
    field :slug, as: :text, readonly: true, only_on: :show
    field :bio, as: :text, hide_on: :index
    field :birth_date, as: :date
    field :death_date, as: :date
    field :recordings_count, as: :number, readonly: true
    field :normalized_name, as: :text, hide_on: :index
    field :orchestra_positions, as: :has_many
    field :recording_singers, as: :has_many
    field :composition_roles, as: :has_many
  end
end
