class Avo::Resources::Genre < Avo::BaseResource
  self.includes = [:recordings]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text
    field :description, as: :textarea
    field :recordings, as: :has_many
  end
end
