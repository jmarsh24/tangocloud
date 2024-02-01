class Avo::Resources::Recording < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :bpm, as: :number
    field :type, as: :select, enum: ::Recording.types
    field :release_date, as: :date
    field :recorded_date, as: :date
    field :el_recodo_song_id, as: :text
    field :orchestra_id, as: :text
    field :singer_id, as: :text
    field :composition_id, as: :text
    field :label_id, as: :text
    field :genre_id, as: :text
    field :period_id, as: :text
    field :el_recodo_song, as: :belongs_to
    field :orchestra, as: :belongs_to
    field :singer, as: :belongs_to
    field :song, as: :belongs_to
    field :label, as: :belongs_to
    field :genre, as: :belongs_to
  end
end
