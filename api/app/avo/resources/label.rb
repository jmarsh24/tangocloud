# frozen_string_literal: true

class Avo::Resources::Label < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :founded_date, as: :date
    field :videos, as: :has_many
  end
end
