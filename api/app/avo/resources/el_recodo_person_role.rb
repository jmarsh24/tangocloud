class Avo::Resources::ElRecodoPersonRole < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :idlo
    field :el_recodo_person_id, as: :text
    field :el_recodo_song_id, as: :text
    field :role, as: :text
    field :el_recodo_person, as: :belongs_to
    field :el_recodo_song, as: :belongs_to
  end
end
