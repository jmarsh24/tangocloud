class Avo::Resources::Album < Avo::BaseResource
  self.includes = [:audio_transfers]
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.find_record_method = -> {
    if id.is_a?(Array)
      query.where(slug: id)
    else
      # We have to add .friendly to the query
      query.friendly.find id
    end
  }

  def fields
    field :id, as: :id, readonly: true, only_on: :show
    field :album_art, as: :file, is_image: true
    field :title, as: :text
    field :description, as: :textarea
    field :release_date, as: :date
    field :audio_transfers_count, as: :number
    field :slug, as: :text, readonly: true, only_on: :show
    field :external_id, as: :text, only_on: :show, readonly: true
    field :album_type, as: :select, enum: ::Album.album_types, only_on: :show
    field :audio_transfers, as: :has_many
  end
end
