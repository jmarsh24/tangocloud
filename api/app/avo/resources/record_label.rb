class Avo::Resources::RecordLabel < Avo::BaseResource
  self.includes = [:recordings, :orchestras, :singers, :compositions, :composers, :lyricists]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :name, as: :text
    field :description, as: :textarea
    field :founded_date, as: :date, only_on: :show
    field :recordings, as: :has_many
    field :orchestras, as: :has_many, through: :recordings
    field :singers, as: :has_many, through: :recordings
    field :compositions, as: :has_many, through: :recordings
    field :composers, as: :has_many, through: :compositions
    field :lyricists, as: :has_many, through: :compositions
  end
end
