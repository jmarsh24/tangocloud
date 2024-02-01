class Avo::Resources::Period < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :start_year, as: :number
    field :end_year, as: :number
    field :recordings_count, as: :number
    field :slug, as: :text
    field :record, as: :belongs_to
  end
end
