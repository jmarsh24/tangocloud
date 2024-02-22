class Avo::Resources::Album < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :title, as: :text
    field :description, as: :textarea
    field :release_date, as: :date
    field :audio_transfers_count, as: :number
    field :slug, as: :text
    field :external_id, as: :text
    field :album_type, as: :select, enum: ::Album.album_types
    field :album_art, as: :file
    field :audio_transfers, as: :has_many
  end
end
