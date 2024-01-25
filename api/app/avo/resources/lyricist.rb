# frozen_string_literal: true

class Avo::Resources::Lyricist < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :slug, as: :text
    field :sort_name, as: :text
    field :birth_date, as: :date
    field :death_date, as: :date
    field :bio, as: :textarea
    field :lyrics, as: :has_many
  end
end
