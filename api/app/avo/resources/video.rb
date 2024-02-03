class Avo::Resources::Video < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :youtube_slug, as: :text
    field :title, as: :text
    field :description, as: :textarea
    field :recording_id, as: :text
    field :recording, as: :belongs_to
  end
end
