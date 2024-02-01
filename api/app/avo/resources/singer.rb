class Avo::Resources::Singer < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :slug, as: :text
    field :rank, as: :number
    field :sort_name, as: :text
    field :bio, as: :textarea
    field :birth_date, as: :date
    field :death_date, as: :date
    field :recording_singers, as: :has_many
    field :recordings, as: :has_many, through: :recording_singers
  end
end
