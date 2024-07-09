class Avo::Resources::CompositionRole < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :role, as: :select, enum: ::CompositionRole.roles
    field :person_id, as: :text
    field :composition_id, as: :text
    field :person, as: :belongs_to
    field :composition, as: :belongs_to
  end
end
