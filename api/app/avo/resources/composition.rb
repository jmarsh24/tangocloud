class Avo::Resources::Composition < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :tangotube_slug, as: :text
    field :genre_id, as: :text
    field :lyricist_id, as: :text
    field :composer_id, as: :text
    field :listens_count, as: :number
    field :popularity, as: :number
    field :lyricist, as: :belongs_to
    field :composer, as: :belongs_to
  end
end
