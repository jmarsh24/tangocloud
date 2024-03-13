class Avo::Resources::Composition < Avo::BaseResource
  self.includes = [:lyricist, :composer, :recordings, :lyrics]
  self.search = {
    query: -> { query.search_compositions(params[:q]) }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :title, as: :text
    field :tangotube_slug, as: :text, only_on: :show
    field :lyricist, as: :belongs_to
    field :composer, as: :belongs_to
    field :recordings, as: :has_many
    field :lyrics, as: :has_many
  end
end
