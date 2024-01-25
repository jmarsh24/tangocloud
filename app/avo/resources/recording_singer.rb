# frozen_string_literal: true

class Avo::Resources::RecordingSinger < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :recording_id, as: :text
    field :singer_id, as: :text
    field :recording, as: :belongs_to
    field :singer, as: :belongs_to
  end
end
