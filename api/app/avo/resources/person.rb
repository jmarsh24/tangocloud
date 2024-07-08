class Avo::Resources::Person < Avo::BaseResource
  self.includes = [:composition_roles, :orchestra_roles, :recording_singers]
  self.search = {
    query: -> { query.search(params[:q]).results }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text
    field :slug, as: :text, readonly: true, only_on: :show
    field :avatar, as: :file, is_image: true, accept: "image/*"
    field :bio, as: :text
    field :birth_date, as: :date
    field :death_date, as: :date
    field :composition_roles, as: :has_many
    field :orchestra_roles, as: :has_many
    field :recording_singers, as: :has_many
  end
end
