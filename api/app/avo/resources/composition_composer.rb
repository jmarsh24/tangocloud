class Avo::Resources::CompositionComposer < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :composition_id, as: :text
    field :composer_id, as: :text
    field :composition, as: :belongs_to
    field :composer, as: :belongs_to
  end
end
