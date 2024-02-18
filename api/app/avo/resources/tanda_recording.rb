class Avo::Resources::TandaRecording < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :position, as: :number
    field :tanda_id, as: :text
    field :recording_id, as: :text
    field :tanda, as: :belongs_to
    field :recording, as: :belongs_to
  end
end
