class Avo::Resources::Album < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, only_on: [:show]
    field :title, as: :text
    field :description, as: :textarea, only_on: [:show, :edit, :new]
    field :release_date, as: :date, only_on: [:show, :edit, :new]
    field :album_type, as: :select, enum: ::Album.types
    field :recordings_count, as: :number
    field :slug, as: :text
    field :external_id, as: :text
    field :transfer_agent_id, as: :text
    field :album_art, as: :file
    field :transfer_agent, as: :belongs_to
    field :recordings, as: :has_many
  end
end
