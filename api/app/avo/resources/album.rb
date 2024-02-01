class Avo::Resources::Album < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :description, as: :textarea
    field :release_date, as: :date
    field :type, as: :select, enum: ::Album.types
    field :recordings_count, as: :number
    field :slug, as: :text
    field :external_id, as: :text
    field :transfer_agent_id, as: :text
    field :cover_image, as: :file
    field :transfer_agent, as: :belongs_to
    field :recordings, as: :has_many
  end
end
