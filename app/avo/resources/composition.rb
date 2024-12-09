class Avo::Resources::Composition < Avo::BaseResource
  self.includes = [:recordings, :composition_lyrics, :lyrics, :composition_roles]
  self.search = {
    query: -> { query.search(params[:q]) }
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :title, as: :text
    field :composers, as: :has_many
    field :lyricists, as: :has_many
    field :recordings, as: :has_many
    field :composition_lyrics, as: :has_many
    field :lyrics, as: :has_many
    field :composition_roles, as: :has_many
    field :digital_remasters, as: :has_many
  end
end
