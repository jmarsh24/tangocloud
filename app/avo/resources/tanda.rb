# frozen_string_literal: true

class Avo::Resources::Tanda < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :public, as: :boolean
    field :audio_transfer_id, as: :text
    field :user_id, as: :text
    field :audio_transfer, as: :belongs_to
  end
end
