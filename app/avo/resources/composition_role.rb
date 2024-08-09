class Avo::Resources::CompositionRole < Avo::BaseResource
  self.includes = [:person, :composition]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, hide_on: :index
    field :role, as: :select, enum: ::CompositionRole.roles
    field :person, as: :belongs_to
    field :composition, as: :belongs_to
  end
end
