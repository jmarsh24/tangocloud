# frozen_string_literal: true

class Avo::Resources::Composer < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :birth_date, as: :date
    field :death_date, as: :date
    field :compositions, as: :has_many
  end
end
