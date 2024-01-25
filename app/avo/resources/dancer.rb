# frozen_string_literal: true

class Avo::Resources::Dancer < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :nickname, as: :text
    field :nationality, as: :text
    field :birth_date, as: :date
    field :death_date, as: :date
    field :dancer_videos, as: :has_many
    field :videos, as: :has_many, through: :dancer_videos
    field :couples, as: :has_many
    field :partners, as: :has_many, through: :couples
  end
end
