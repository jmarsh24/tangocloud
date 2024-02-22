class Avo::Resources::Couple < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :dancer_id, as: :text
    field :partner_id, as: :text
    field :dancer, as: :belongs_to
    field :partner, as: :belongs_to
    field :couple_videos, as: :has_many
    field :videos, as: :has_many, through: :couple_videos
  end
end
