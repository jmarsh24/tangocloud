class Avo::Resources::OrchestraRole < Avo::BaseResource
  self.includes = [:orchestra_positions, :orchestras]
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :idlo
    field :name, as: :text
    field :orchestra_positions, as: :has_many
    field :orchestras, as: :has_many
  end
end
