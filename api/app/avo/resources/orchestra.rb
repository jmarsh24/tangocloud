# frozen_string_literal: true

class Avo::Resources::Orchestra < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :rank, as: :number
    field :sort_name, as: :text
    field :birth_date, as: :date
    field :death_date, as: :date
    field :slug, as: :text
    field :orchestra_recordings, as: :has_many
    field :recordings, as: :has_many, through: :orchestra_recordings
    field :singers, as: :has_many, through: :recordings
    field :compositions, as: :has_many, through: :recordings
    field :composers, as: :has_many, through: :compositions
    field :lyricists, as: :has_many, through: :compositions
  end
end
