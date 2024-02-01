class Avo::Resources::Lyric < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :locale, as: :text
    field :content, as: :textarea
    field :composition_id, as: :text
    field :composition, as: :belongs_to
  end
end
