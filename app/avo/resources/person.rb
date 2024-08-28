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
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      query.friendly.find id
    end
  }

  def fields
    field :image, as: :file, is_image: true, accept: "image/*"
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text
    field :slug, as: :text, readonly: true, only_on: :show
    field :bio, as: :text, hide_on: :index
    field :birth_date, as: :date
    field :death_date, as: :date
    field :normalized_name, as: :text, hide_on: :index
    field :orchestra_positions, as: :has_many
    field :recording_singers, as: :has_many
    field :composition_roles, as: :has_many
  end
end
