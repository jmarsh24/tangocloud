class Avo::Resources::CoupleVideo < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :couple_id, as: :text
    field :video_id, as: :text
    field :couple, as: :belongs_to
    field :video, as: :belongs_to
  end
end
