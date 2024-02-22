class Avo::Resources::Composition < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :title, as: :text
    field :tangotube_slug, as: :text
    field :lyricist_id, as: :text
    field :composer_id, as: :text
    field :lyricist, as: :belongs_to
    field :composer, as: :belongs_to
    field :recordings, as: :has_many
    field :lyrics, as: :has_many
  end
end
