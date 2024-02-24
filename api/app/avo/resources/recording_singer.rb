class Avo::Resources::RecordingSinger < Avo::BaseResource
  self.includes = [:recording, :singer]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :recording, as: :belongs_to
    field :singer, as: :belongs_to
  end
end
