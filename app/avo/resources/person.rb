class Avo::Resources::Person < Avo::BaseResource
  self.includes = [:orchestra_positions, :recording_singers, :composition_roles]
  self.attachments = [:image]
  self.search = {
    query: -> {
             query.search(params[:q],
               fields: [:name],
               match: :word_start,
               misspellings: {below: 5})
           }
  }

  def fields
    field :image, as: :file, is_image: true, accept: "image/*"
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text
    field :slug, as: :text, readonly: true, only_on: :show
    field :bio, as: :text, hide_on: :index
    field :birth_date, as: :date
    field :death_date, as: :date
    field :orchestra_positions, as: :has_many
    field :recording_singers, as: :has_many
    field :composition_roles, as: :has_many
  end
end
